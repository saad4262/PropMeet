import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../push_services.dart';

class UserSideHomeServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ❤️ User likes another user
  Future<void> likeUser(String currentUserId, String likedUserId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Save "liked" relationship
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('liked')
          .doc(likedUserId)
          .set({'createdAt': FieldValue.serverTimestamp()});

      // Check for mutual like → Match
      final matchCheck = await _firestore
          .collection('users')
          .doc(likedUserId)
          .collection('liked')
          .doc(currentUserId)
          .get();

      if (matchCheck.exists) {
        // 🎉 It's a match!
        await _createNotification(
          toUserId: likedUserId,
          type: 'match',
          fromUser: currentUser,
        );

        final likedUserDoc =
        await _firestore.collection('users').doc(likedUserId).get();

        await _createNotification(
          toUserId: currentUserId,
          type: 'match',
          fromUser: likedUserDoc,
        );

        // Save match info
        await _firestore.collection('matches').add({
          'users': [currentUserId, likedUserId],
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // ❤️ Normal "like"
        await _createNotification(
          toUserId: likedUserId,
          type: 'liked',
          fromUser: currentUser,
        );
      }
    } catch (e) {
      print('❌ Error in likeUser(): $e');
    }
  }

  /// 🛎 Create notification (safe version)
  Future<void> _createNotification({
    required String toUserId,
    required dynamic fromUser, // Firebase User or DocumentSnapshot
    required String type, // 'liked' or 'match'
  }) async {
    try {
      String? fromId;
      String? fromName;
      String? fromEmail;

      // Identify sender
      if (fromUser is User) {
        fromId = fromUser.uid;
        fromName = fromUser.displayName ?? fromUser.email ?? 'Someone';
        fromEmail = fromUser.email ?? '';
      } else if (fromUser is DocumentSnapshot) {
        final data = fromUser.data() as Map<String, dynamic>? ?? {};
        fromId = fromUser.id;
        fromName = data['firstName'] ?? data['name'] ?? data['email'] ?? 'Someone';
        fromEmail = data['email'] ?? '';
      } else if (fromUser is String) {
        final udoc = await _firestore.collection('users').doc(fromUser).get();
        final ud = udoc.data() ?? {};
        fromId = fromUser;
        fromName = ud['firstName'] ?? ud['name'] ?? ud['email'] ?? 'Someone';
        fromEmail = ud['email'] ?? '';
      }

      final notificationData = {
        'type': type,
        'fromId': fromId,
        'fromName': fromName,
        'fromEmail': fromEmail,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      };

      // --- Save Notification ---
      final usersRef = _firestore.collection('users').doc(toUserId);
      final userDoc = await usersRef.get();

      if (userDoc.exists) {
        await usersRef.collection('notifications').add(notificationData);
      } else {
        // fallback: nested agent profile path
        final agentProfileRef = _firestore
            .collection('users')
            .doc(toUserId)
            .collection('agentProfile')
            .doc('profile');
        final agentDoc = await agentProfileRef.get();

        if (agentDoc.exists) {
          await agentProfileRef.collection('notifications').add(notificationData);
        } else {
          // fallback to users anyway
          await usersRef.collection('notifications').add(notificationData);
        }
      }

      // --- Send Push Notification ---
      String? fcmToken;

      if (userDoc.exists) {
        fcmToken = userDoc.data()?['fcmToken'] ??
            userDoc.data()?['token'] ??
            userDoc.data()?['pushToken'];
      } else {
        final agentProfileRef = _firestore
            .collection('users')
            .doc(toUserId)
            .collection('agentProfile')
            .doc('profile');
        final agentDoc = await agentProfileRef.get();
        if (agentDoc.exists) {
          final data = agentDoc.data() ?? {};
          fcmToken = data['fcmToken'] ?? data['token'] ?? data['pushToken'];
        }
      }

      if (fcmToken != null && fcmToken.isNotEmpty) {
        final title = type == 'match' ? '🎉 It\'s a Match!' : '❤️ Someone liked you!';
        final body = type == 'match'
            ? '${fromName ?? 'Someone'} matched with you!'
            : '${fromName ?? 'Someone'} liked your profile!';
        await sendPushMessage(token: fcmToken, title: title, body: body);
      }
    } catch (e, st) {
      print('⚠️ Error creating notification: $e\n$st');
    }
  }

  // --- Favourites and Swipe Helpers ---
  Future<void> addFavourite(String userId, String agentId) async {
    await _firestore.collection("users").doc(userId).set({
      "swipes": {
        "favourites": FieldValue.arrayUnion([agentId]),
      }
    }, SetOptions(merge: true));
  }

  Future<void> removeFavourite(String userId, String agentId) async {
    await _firestore.collection("users").doc(userId).set({
      "swipes": {
        "favourites": FieldValue.arrayRemove([agentId]),
      }
    }, SetOptions(merge: true));
  }

  Future<List<String>> getFavourites(String userId) async {
    final snapshot = await _firestore.collection("users").doc(userId).get();
    final data = snapshot.data();
    if (data == null) return [];
    final favs = (data["swipes"]?["favourites"]) ?? [];
    return List<String>.from(favs);
  }

  Future<void> addLike(String userId, String agentId) async {
    await _firestore.collection("users").doc(userId).set({
      "swipes": {
        "liked": FieldValue.arrayUnion([agentId]),
      }
    }, SetOptions(merge: true));
  }

  Future<void> addDislike(String userId, String agentId) async {
    await _firestore.collection("users").doc(userId).set({
      "swipes": {
        "disliked": FieldValue.arrayUnion([agentId]),
      }
    }, SetOptions(merge: true));
  }
}
