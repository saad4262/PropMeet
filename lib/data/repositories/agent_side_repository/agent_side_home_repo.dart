import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propmeet/data/services/agent_side_services/agent_side_home_services.dart';
import '../../../model/user_model/user_model.dart';

class AgentSideHomeRepo {
  final AgentSideHomeServices firebaseService = AgentSideHomeServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFavourites(String agentId, String userId) {
    return firebaseService.addFavourite(agentId, userId);
  }

  Future<void> removeFromFavourites(String agentId, String userId) {
    return firebaseService.removeFavourite(agentId, userId);
  }

  Future<void> likeAgent(String userId, String agentId) {
    return firebaseService.addLike(userId, agentId);
  }

  Future<void> dislikeAgent(String userId, String agentId) {
    return firebaseService.addDislike(userId, agentId);
  }

  Future<bool> checkMatch(String agentId, String userId) {
    return firebaseService.checkMatch(agentId, userId);
  }

  Future<void> saveMatch(String agentId, String userId) {
    return firebaseService.saveMatch(agentId, userId);
  }

  Future<List<String>> fetchFavourites(String agentId) async {
    final snapshot =
    await _firestore.collection('favourites').doc(agentId).get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      final List<dynamic> favIds = data['favouriteUserIds'] ?? [];
      return favIds.cast<String>();
    }
    return [];
  }

  /// ✅ Fetch full user profiles by their IDs
  Future<List<UserModel>> fetchUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final snapshot = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    List<UserModel> users = [];

    for (var doc in snapshot.docs) {
      final setupDoc = await _firestore
          .collection('users')
          .doc(doc.id)
          .collection('profile_user')
          .doc('setupData')
          .get();

      final setupData = setupDoc.data() ?? {};
      users.add(UserModel.fromMap(doc.data(), setupData, userId: doc.id));
    }

    return users;
  }
}
