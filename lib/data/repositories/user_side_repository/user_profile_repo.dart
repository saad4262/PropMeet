import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../model/agent_model/agent_model.dart';
import '../../../model/user_model/user_model.dart';

class UserProfileRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> fetchUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final userDoc = await _db.collection('users').doc(uid).get();
    final setupDoc = await _db
        .collection('users')
        .doc(uid)
        .collection('profile_user')
        .doc('setupData')
        .get();

    if (userDoc.exists && setupDoc.exists) {
      return UserModel.fromFirestore(userDoc, setupDoc.data()!);
    }
    return null;
  }

  Future<void> updateUserProfile(UserModel user) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection("users").doc(uid).set({
      "name": user.name,
      "email": user.email,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _db
        .collection("users")
        .doc(uid)
        .collection("profile_user")
        .doc("setupData")
        .set({
      "location": user.location,
      "progress": user.progress,
      "propertyDetails": user.propertyDetails.toMap(),
      "selections": user.selections,
    }, SetOptions(merge: true));
  }

  Future<List<UserModel>> fetchAllUsers() async {
    final querySnapshot = await _db.collection("users").get();

    List<UserModel> users = [];
    for (var doc in querySnapshot.docs) {
      try {
        final setupDoc = await _db
            .collection("users")
            .doc(doc.id)
            .collection("profile_user")
            .doc("setupData")
            .get();

        final setupData = setupDoc.data() ?? {};
        users.add(UserModel.fromFirestore(doc, setupData));
      } catch (e) {
        print("Error parsing user ${doc.id}: $e");
      }
    }
    return users;
  }

  Future<List<UserModel>> fetchAllUsersForCards() async {
    final snapshot = await _db.collection("users").get();

    List<UserModel> users = [];
    for (var doc in snapshot.docs) {
      final rootData = doc.data();

      if ((rootData["tag"] ?? "").toString().toLowerCase() == "agent") {
        continue;
      }

      final setupDoc = await _db
          .collection("users")
          .doc(doc.id)
          .collection("profile_user")
          .doc("setupData")
          .get();

      final setupData = setupDoc.data() ?? {};

      try {
        users.add(UserModel.fromFirestore(doc, setupData));
      } catch (e) {
        print("Error building UserModel for ${doc.id}: $e");
      }
    }

    return users;
  }

  Future<List<UserModel>> fetchUsersByTag(String tag) async {
    final snapshot = await _db
        .collection("users")
        .where("tag", isEqualTo: tag)
        .get();

    List<UserModel> users = [];
    for (var doc in snapshot.docs) {
      try {
        final setupDoc = await _db
            .collection("users")
            .doc(doc.id)
            .collection("profile_user")
            .doc("setupData")
            .get();

        final setupData = setupDoc.data() ?? {};
        users.add(UserModel.fromFirestore(doc, setupData));
      } catch (e) {
        print("Error parsing user ${doc.id}: $e");
      }
    }
    return users;
  }

  Future<List<AgentFieldData>> fetchAllAgents() async {
    final snapshot = await _db
        .collection("users")
        .where("tag", isEqualTo: "agent")
        .get();

    List<AgentFieldData> agents = [];
    for (var doc in snapshot.docs) {
      try {
        final setupDoc = await _db
            .collection("users")
            .doc(doc.id)
            .collection("agentProfile")
            .doc("profile")
            .get();

        agents.add(AgentFieldData.fromFirestore(
          doc.data(),
          setupDoc.data() ?? {},
        ));
      } catch (e) {
        print("Error parsing agent ${doc.id}: $e");
      }
    }
    return agents;
  }

}
