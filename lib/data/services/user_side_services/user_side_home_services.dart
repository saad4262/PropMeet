import 'package:cloud_firestore/cloud_firestore.dart';

class UserSideHomeServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFavourite(String userId, String agentId) async {
    await _db.collection("users").doc(userId).set({
      "swipes": {
        "favourites": FieldValue.arrayUnion([agentId]),
      }
    }, SetOptions(merge: true));
  }

  Future<void> removeFavourite(String userId, String agentId) async {
    await _db.collection("users").doc(userId).set({
      "swipes": {
        "favourites": FieldValue.arrayRemove([agentId]),
      }
    }, SetOptions(merge: true));
  }

  Future<List<String>> getFavourites(String userId) async {
    final snapshot = await _db.collection("users").doc(userId).get();
    final data = snapshot.data();
    if (data == null) return [];
    final favs = (data["swipes"]?["favourites"]) ?? [];
    return List<String>.from(favs);
  }

  Future<void> addLike(String userId, String agentId) async {
    await _db.collection("users").doc(userId).set({
      "swipes": {
        "liked": FieldValue.arrayUnion([agentId]),
      }
    }, SetOptions(merge: true));
  }

  Future<void> addDislike(String userId, String agentId) async {
    await _db.collection("users").doc(userId).set({
      "swipes": {
        "disliked": FieldValue.arrayUnion([agentId]),
      }
    }, SetOptions(merge: true));
  }
}
