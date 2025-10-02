import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SwipeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addFavourite(String targetUserId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection("users").doc(uid).collection("favourites").doc(targetUserId).set({
      "targetUserId": targetUserId,
      "createdAt": FieldValue.serverTimestamp(),
    });

    // Increment swipe count
    await _db.collection("users").doc(uid).set({
      "swipeCount": FieldValue.increment(1),
      "likeCount": FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  /// Add to dislikes
  Future<void> addDislike(String targetUserId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection("users").doc(uid).collection("dislikes").doc(targetUserId).set({
      "targetUserId": targetUserId,
      "createdAt": FieldValue.serverTimestamp(),
    });

    await _db.collection("users").doc(uid).set({
      "swipeCount": FieldValue.increment(1),
      "dislikeCount": FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  /// Get favourites
  Future<List<String>> fetchFavourites() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await _db.collection("users").doc(uid).collection("favourites").get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /// Get dislikes
  Future<List<String>> fetchDislikes() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await _db.collection("users").doc(uid).collection("dislikes").get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> addFavouriteAndCheckMatch(String targetUserId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Step 1: Add current user’s like
    await addFavourite(targetUserId);

    // Step 2: Check if target user also liked me
    final targetFavourite = await _db
        .collection("users")
        .doc(targetUserId)
        .collection("favourites")
        .doc(uid)
        .get();

    if (targetFavourite.exists) {
      // 🎉 It's a match!
      await _createChatRoom(uid, targetUserId);
      // TODO: send FCM notification
    }
  }

  Future<void> _createChatRoom(String userA, String userB) async {
    final chatId = userA.hashCode <= userB.hashCode
        ? "${userA}_$userB"
        : "${userB}_$userA";

    await _db.collection("chats").doc(chatId).set({
      "members": [userA, userB],
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

}
