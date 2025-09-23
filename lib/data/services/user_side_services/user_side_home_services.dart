import 'package:cloud_firestore/cloud_firestore.dart';

class UserSideHomeServices{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFavourite(String userId, String agentId) async {
    await _db.collection("users").doc(userId).update({
      "swipes.favourites": FieldValue.arrayUnion([agentId])
    });
  }

  Future<void> removeFavourite(String userId, String agentId) async {
    await _db.collection("users").doc(userId).update({
      "swipes.favourites": FieldValue.arrayRemove([agentId])
    });
  }

  Future<List<String>> getFavourites(String userId) async {
    final snapshot = await _db.collection("users").doc(userId).get();
    final data = snapshot.data();
    if (data == null) return [];
    final favs = data["swipes"]["favourites"] ?? [];
    return List<String>.from(favs);
  }

  Future<void> addLike(String userId, String agentId) async {
    await _db.collection("users").doc(userId).update({
      "swipes.liked": FieldValue.arrayUnion([agentId])
    });
  }

  Future<void> addDislike(String userId, String agentId) async {
    await _db.collection("users").doc(userId).update({
      "swipes.disliked": FieldValue.arrayUnion([agentId])
    });
  }
}