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

  Future<void> recordSwipe({
    required String agentUserId,
    required String currentUserId,
    required bool liked,
  }) async {
    final docRef = _db.collection('users').doc(agentUserId);
    final field = 'swipes';
    await _db.runTransaction((txn) async {
      final snapshot = await txn.get(docRef);
      final data = snapshot.data() ?? {};
      final Map swipes = Map.from(data[field] ?? {});
      int count = (swipes['count'] ?? 0) as int;
      List likedList = List.from(swipes['liked'] ?? []);
      List dislikedList = List.from(swipes['disliked'] ?? []);
      count += 1;
      if (liked) {
        if (!likedList.contains(currentUserId)) likedList.add(currentUserId);
        dislikedList.remove(currentUserId);
      } else {
        if (!dislikedList.contains(currentUserId)) dislikedList.add(currentUserId);
        likedList.remove(currentUserId);
      }
      txn.set(docRef, {
        field: {
          'count': count,
          'liked': likedList,
          'disliked': dislikedList,
        }
      }, SetOptions(merge: true));
    });
  }

  Future<List<AgentFieldData>> fetchFavouriteAgents() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      print("⚠️ No user logged in");
      return [];
    }

    try {
      print("👤 Fetching favourites for user: $uid");
      final userDoc = await _db.collection("users").doc(uid).get();

      if (!userDoc.exists) {
        print("⚠️ User doc not found");
        return [];
      }

      final rootData = userDoc.data() ?? {};
      List<dynamic> favs = rootData['swipes']?['favourites'] ?? [];
      print("🔥 Favourite IDs: $favs");

      if (favs.isEmpty) return [];

      List<AgentFieldData> agents = [];
      for (String favId in favs) {
        print("🔍 Fetching agent: $favId");

        final favDoc = await _db.collection("users").doc(favId).get();
        if (favDoc.exists) {
          final setupDoc = await _db
              .collection("users")
              .doc(favId)
              .collection("agentProfile")
              .doc("profile")
              .get();

          final setupData = setupDoc.data() ?? {};
          agents.add(AgentFieldData.fromFirestore(
            favDoc.data()!,
            setupData,
          ));
          print("✅ Added agent: $favId");
        } else {
          print("⚠️ Agent $favId doc not found");
        }
      }

      print("🎉 Returning ${agents.length} agents");
      return agents;
    } catch (e) {
      print("❌ Error in fetchFavouriteAgents repo: $e");
      return [];
    }
  }

}
