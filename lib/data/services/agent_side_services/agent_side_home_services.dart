// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AgentSideHomeServices {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   // Future<void> addFavourite(String agentId, String userId) async {
//   //   await _db.collection('agents').doc(agentId).update({
//   //     "favourites": FieldValue.arrayUnion([userId]),
//   //   });
//   // }
//
//   Future<void> removeFavourite(String agentId, String userId) async {
//     await _db.collection('agents').doc(agentId).update({
//       "favourites": FieldValue.arrayRemove([userId]),
//     });
//   }
//
//   Future<List<String>> getFavourites(String agentId) async {
//     final doc = await _db.collection('agents').doc(agentId).get();
//     return List<String>.from(doc.data()?['favourites'] ?? []);
//   }
//
//   Future<void> addLike(String userId, String agentId) async {
//     await _db.collection('users').doc(userId).update({
//       "favourites": FieldValue.arrayUnion([agentId]),
//     });
//   }
//
//   Future<void> addDislike(String userId, String agentId) async {
//     await _db.collection('users').doc(userId).update({
//       "dislikes": FieldValue.arrayUnion([agentId]),
//     });
//   }
//
//   // Check mutual match
//   Future<bool> checkMatch(String agentId, String userId) async {
//     final agentDoc = await _db.collection('agents').doc(agentId).get();
//     final userDoc = await _db.collection('users').doc(userId).get();
//
//     final agentFavs = List<String>.from(agentDoc.data()?['favourites'] ?? []);
//     final userFavs = List<String>.from(userDoc.data()?['favourites'] ?? []);
//
//     return agentFavs.contains(userId) && userFavs.contains(agentId);
//   }
//
//   //Save match for both sides
//   Future<void> saveMatch(String agentId, String userId) async {
//     await _db.collection('agents').doc(agentId).update({
//       "matches": FieldValue.arrayUnion([userId]),
//     });
//     await _db.collection('users').doc(userId).update({
//       "matches": FieldValue.arrayUnion([agentId]),
//     });
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class AgentSideHomeServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFavourite(String agentId, String userId) async {
    await _db.collection('agents').doc(agentId).update({
      "favourites": FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeFavourite(String agentId, String userId) async {
    await _db.collection('agents').doc(agentId).update({
      "favourites": FieldValue.arrayRemove([userId]),
    });
  }

  Future<List<String>> getFavourites(String agentId) async {
    final doc = await _db.collection('agents').doc(agentId).get();
    return List<String>.from(doc.data()?['favourites'] ?? []);
  }

  Future<void> addLike(String userId, String agentId) async {
    await _db.collection('users').doc(userId).update({
      "favourites": FieldValue.arrayUnion([agentId]),
    });
  }

  Future<void> addDislike(String userId, String agentId) async {
    await _db.collection('users').doc(userId).update({
      "dislikes": FieldValue.arrayUnion([agentId]),
    });
  }

  // Check mutual match
  Future<bool> checkMatch(String agentId, String userId) async {
    final agentDoc = await _db.collection('agents').doc(agentId).get();
    final userDoc = await _db.collection('users').doc(userId).get();

    final agentFavs = List<String>.from(agentDoc.data()?['favourites'] ?? []);
    final userFavs = List<String>.from(userDoc.data()?['favourites'] ?? []);

    return agentFavs.contains(userId) && userFavs.contains(agentId);
  }

  //Save match for both sides
  Future<void> saveMatch(String agentId, String userId) async {
    await _db.collection('agents').doc(agentId).update({
      "matches": FieldValue.arrayUnion([userId]),
    });
    await _db.collection('users').doc(userId).update({
      "matches": FieldValue.arrayUnion([agentId]),
    });
  }
}