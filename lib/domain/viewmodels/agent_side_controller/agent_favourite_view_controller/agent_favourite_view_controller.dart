import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:propmeet/model/user_model/user_model.dart';

class AgentFavouriteViewController extends GetxController {
  var favouriteUsers = <UserModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) listenToFavouriteUsers(currentUser.uid);
  }

  /// 🔁 Listen to agent favourites
  void listenToFavouriteUsers(String agentId) {
    _firestore
        .collection('agentProfile')
        .doc(agentId)
        .collection('favourites')
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docs.isEmpty) {
        favouriteUsers.clear();
        return;
      }

      final userIds = snapshot.docs.map((d) => d.id).toList();
      final usersQuery = await _firestore
          .collection('profile_user')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      final users = usersQuery.docs.map((doc) {
        final rootData = Map<String, dynamic>.from(doc.data());
        return UserModel.fromMap(rootData, {}, userId: doc.id);
      }).toList();

      favouriteUsers.assignAll(users);
    });
  }
}
