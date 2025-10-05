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

      // 1️⃣ Save "liked" relationship (for current user)
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('liked')
          .doc(likedUserId)
          .set({'createdAt': FieldValue.serverTimestamp()});

      // 2️⃣ Check if likedUser also liked currentUser → It's a match!
      final matchCheck = await _firestore
          .collection('users')
          .doc(likedUserId)
          .collection('liked')
          .doc(currentUserId)
          .get();

      if (matchCheck.exists) {
        // 🔥 Both liked each other — Create a match notification for both sides
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

  // NOTE: put this inside UserSideHomeServices class (replace existing _createNotification)
  Future<void> _createNotification({
    required String toUserId,
    required dynamic fromUser, // Firebase User or DocumentSnapshot
    required String type, // 'liked' or 'match'
  }) async {
    try {
      String? fromId;
      String? fromName;
      String? fromEmail;

      if (fromUser is User) {
        fromId = fromUser.uid;
        fromName = fromUser.displayName ?? fromUser.email ?? 'Someone';
        fromEmail = fromUser.email ?? '';
      } else if (fromUser is DocumentSnapshot) {
        final data = fromUser.data() as Map<String, dynamic>?;
        fromId = fromUser.id;
        fromName = data?['firstName'] ??
            data?['name'] ??
            data?['fullName'] ??
            data?['email'] ??
            'Someone';
        fromEmail = data?['email'] ?? '';
      } else if (fromUser is String) {
        // optional: if you pass just an id
        fromId = fromUser;
        final udoc = await FirebaseFirestore.instance.collection('users').doc(fromUser).get();
        final ud = udoc.data() ?? {};
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

      // Save notification in Firestore (try users, then agentProfile)
      final usersRef = FirebaseFirestore.instance.collection('users').doc(toUserId);
      final agentRef = FirebaseFirestore.instance.collection('agentProfile').doc(toUserId);

      // prefer users collection
      var receiverDoc = await usersRef.get();
      if (receiverDoc.exists) {
        await usersRef.collection('notifications').add(notificationData);
      } else {
        // fallback to agentProfile
        receiverDoc = await agentRef.get();
        if (receiverDoc.exists) {
          await agentRef.collection('notifications').add(notificationData);
        } else {
          // if not found anywhere, still try to write to users path
          await usersRef.collection('notifications').add(notificationData);
        }
      }

      // Now send FCM push if token exists (check both collections)
      String? fcmToken;
      if (receiverDoc.exists) {
        final rd = receiverDoc.data() as Map<String, dynamic>? ?? {};
        fcmToken = rd['fcmToken'] ?? rd['token'] ?? rd['pushToken'];
      } else {
        // re-check users doc quickly
        final recheck = await usersRef.get();
        fcmToken = recheck.exists ? (recheck.data()?['fcmToken']) : null;
      }

      if (fcmToken != null && fcmToken.toString().isNotEmpty) {
        final title = type == 'match' ? '🎉 It\'s a Match!' : '❤️ Someone liked you!';
        final body = type == 'match'
            ? '${fromName ?? 'Someone'} matched with you!'
            : '${fromName ?? 'Someone'} liked your profile!';
        await sendPushMessage(token: fcmToken.toString(), title: title, body: body);
      }
    } catch (e, st) {
      print('⚠️ Error creating notification: $e\n$st');
    }
  }



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
