import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserType { agent, user }

class SwipeRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// ✅ Main swipe handler
  Future<void> recordSwipe({
    required String targetId,
    required bool liked,
    required UserType currentUserType,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    if (liked) {
      await _handleLike(likerId: currentUserId, likedId: targetId);
    } else {
      await _handleDislike(dislikerId: currentUserId, dislikedId: targetId);
    }
  }

  /// ❤️ When user swipes right (like)
  Future<void> _handleLike({
    required String likerId,
    required String likedId,
  }) async {
    final likerRef = _db.collection('swipes').doc(likerId);
    final likedRef = _db.collection('swipes').doc(likedId);

    // ✅ Add liked user to liker’s liked list
    await likerRef.set({
      'liked': FieldValue.arrayUnion([likedId])
    }, SetOptions(merge: true));

    // ✅ Fetch liked user’s swipe data
    final likedSnap = await likedRef.get();
    final likedData = likedSnap.data();
    final theirLikes = (likedData?['liked'] as List?) ?? [];

    // 🎯 Check for mutual like
    if (theirLikes.contains(likerId)) {
      await _saveMatch(likerId, likedId);
    } else {
      await _createNotification(receiverId: likedId, senderId: likerId, type: 'liked');
    }
  }

  /// 💔 When user swipes left (dislike)
  Future<void> _handleDislike({
    required String dislikerId,
    required String dislikedId,
  }) async {
    final dislikerRef = _db.collection('swipes').doc(dislikerId);
    await dislikerRef.set({
      'disliked': FieldValue.arrayUnion([dislikedId])
    }, SetOptions(merge: true));
  }

  /// 🎯 Save mutual match
  Future<void> _saveMatch(String userA, String userB) async {
    final refA = _db.collection('swipes').doc(userA);
    final refB = _db.collection('swipes').doc(userB);

    await refA.set({
      'matched': FieldValue.arrayUnion([userB])
    }, SetOptions(merge: true));

    await refB.set({
      'matched': FieldValue.arrayUnion([userA])
    }, SetOptions(merge: true));

    // 🔔 Notify both users
    await _createNotification(receiverId: userB, senderId: userA, type: 'match');
    await _createNotification(receiverId: userA, senderId: userB, type: 'match');
  }

  /// 🔔 Create Firestore notification document
  Future<void> _createNotification({
    required String receiverId,
    required String senderId,
    required String type,
  }) async {
    final senderDoc = await _db.collection('users').doc(senderId).get();
    final senderData = senderDoc.data() ?? {};
    final senderName = senderData['firstName'] ?? senderData['name'] ?? senderData['email'] ?? 'Someone';

    await _db
        .collection('notifications')
        .doc(receiverId)
        .collection('userNotifications')
        .add({
      'type': type,
      'fromId': senderId,
      'fromName': senderName,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
