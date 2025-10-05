import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserType { agent, user }

class SwipeRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // 🔹 Unified way to get correct subcollection path
  String _collectionPath(UserType type) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    return type == UserType.agent
        ? 'users/$userId/agentProfile/profile'
        : 'users/$userId/profile_user/setupData';
  }

  /// ✅ Called on swipe action
  Future<void> recordSwipe({
    required String targetId,
    required bool liked,
    required UserType currentUserType,
    required UserType targetType,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    if (liked) {
      await _handleLike(
        likerId: currentUserId,
        likedId: targetId,
        likerIsUser: currentUserType == UserType.user,
      );
    } else {
      await _handleDislike(
        dislikerId: currentUserId,
        dislikedId: targetId,
        dislikerIsUser: currentUserType == UserType.user,
      );
    }
  }

  /// ❤️ When user swipes right (like)
  Future<void> _handleLike({
    required String likerId,
    required String likedId,
    required bool likerIsUser,
  }) async {
    final likerCollection =
    likerIsUser ? 'users/$likerId/profile_user/setupData' : 'users/$likerId/agentProfile/profile';
    final likedCollection =
    likerIsUser ? 'users/$likedId/agentProfile/profile' : 'users/$likedId/profile_user/setupData';

    final likerRef = _db.doc(likerCollection);
    final likedRef = _db.doc(likedCollection);

    // Add liked user to liker’s liked list
    await likerRef.set({
      'swipes': {
        'liked': FieldValue.arrayUnion([likedId])
      }
    }, SetOptions(merge: true));

    // Check if target already liked back
    final likedSnap = await likedRef.get();
    final likedData = likedSnap.data();
    final theirLikes = (likedData?['swipes']?['liked'] as List?) ?? [];

    if (theirLikes.contains(likerId)) {
      // 🎯 Mutual match
      await _saveMatch(likerRef, likedRef, likerId, likedId);
    } else {
      // 💌 Notify target about "like"
      await _createNotification(
        receiverRef: likedRef,
        senderId: likerId,
        type: 'liked',
        senderIsUser: likerIsUser,
      );
    }
  }

  /// 💔 When user swipes left (dislike)
  Future<void> _handleDislike({
    required String dislikerId,
    required String dislikedId,
    required bool dislikerIsUser,
  }) async {
    final dislikerCollection =
    dislikerIsUser ? 'users/$dislikerId/profile_user/setupData' : 'users/$dislikerId/agentProfile/profile';
    final dislikerRef = _db.doc(dislikerCollection);

    await dislikerRef.set({
      'swipes': {
        'disliked': FieldValue.arrayUnion([dislikedId])
      }
    }, SetOptions(merge: true));
  }

  /// 🎯 Save mutual match
  Future<void> _saveMatch(
      DocumentReference likerRef,
      DocumentReference likedRef,
      String likerId,
      String likedId,
      ) async {
    await likerRef.set({
      'swipes': {
        'matched': FieldValue.arrayUnion([likedId])
      }
    }, SetOptions(merge: true));

    await likedRef.set({
      'swipes': {
        'matched': FieldValue.arrayUnion([likerId])
      }
    }, SetOptions(merge: true));

    // 🔔 Notify both users
    await _createNotification(
        receiverRef: likedRef, senderId: likerId, type: 'match');
    await _createNotification(
        receiverRef: likerRef, senderId: likedId, type: 'match');
  }

  /// 🔔 Create Firestore notification document
  Future<void> _createNotification({
    required DocumentReference receiverRef,
    required String senderId,
    required String type,
    bool? senderIsUser,
  }) async {
    final senderCollection = senderIsUser == null
        ? 'profile_user'
        : (senderIsUser ? 'users/$senderId/profile_user/setupData' : 'users/$senderId/agentProfile/profile');

    final senderDoc = await _db.doc(senderCollection).get();
    final senderData = senderDoc.data() ?? {};
    final senderName = senderData['firstName'] ??
        senderData['name'] ??
        senderData['email'] ??
        'Someone';

    await receiverRef.collection('notifications').add({
      'type': type, // liked / match
      'fromId': senderId,
      'fromName': senderName,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 🚀 (Later — FCM push)
    // final receiverToken = (await receiverRef.get()).data()?['fcmToken'];
    // if (receiverToken != null) sendPush(receiverToken, type, senderName);
  }
}
