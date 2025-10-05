
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:propmeet/model/user_model/user_model.dart';

class AgentFavouriteViewController extends GetxController {

  AgentFavouriteViewController() {
    print("🔥 AgentFavouriteViewController CREATED");
  }

  @override
  void onInit() {
    super.onInit();
    print("🚀 onInit called for AgentFavouriteViewController");

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("👤 Current user id: ${currentUser.uid}");
      listenToFavouriteUsers(currentUser.uid);
    } else {
      print("❌ No logged-in user found!");
    }
  }


  var favouriteUsers = <UserModel>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Load favourite users once
  Future<void> loadFavouriteUsers(String currentUserId) async {
    try {
      // Get current user's document
      final userDoc = await _firestore.collection('users').doc(currentUserId).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final List<dynamic> likedIds = userData['swipes']?['liked'] ?? [];

        if (likedIds.isNotEmpty) {
          // Fetch all users whose IDs are in likedIds
          final query = await _firestore
              .collection('users')
              .where(FieldPath.documentId, whereIn: likedIds)
              .get();

          final users = query.docs.map((doc) {
            // 👇 Firestore stores user data in 2 levels (root + setupData)
            final rootData = doc.data();
            final setupData = rootData['agentProfile'] ?? {}; // or whichever subcollection you use
            return UserModel.fromMap(rootData, setupData, userId: doc.id);
          }).toList();

          favouriteUsers.assignAll(users);
        } else {
          favouriteUsers.clear();
        }
      }
    } catch (e) {
      print("Error loading favourites: $e");
    }
  }


  void listenToFavouriteUsers(String currentUserId) {
    _firestore.collection('users').doc(currentUserId).snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final List<dynamic> likedIds = data['swipes']?['liked'] ?? [];

        print("🔥 Current user $currentUserId liked IDs: $likedIds");

        if (likedIds.isNotEmpty) {
          try {
            final query = await _firestore
                .collection('users')
                .where(FieldPath.documentId, whereIn: likedIds)
                .get();

            print("✅ Query returned ${query.docs.length} docs");

            final users = query.docs.map((doc) {
              final rootData = Map<String, dynamic>.from(doc.data());
              final setupData = Map<String, dynamic>.from(rootData['agentProfile'] ?? {});
              return UserModel.fromMap(rootData, setupData, userId: doc.id);
            }).toList();


            favouriteUsers.assignAll(users);

            for (var u in favouriteUsers) {
              print("⭐ Favourite User: id=${u.userId}, name=${u.name}, email=${u.email}, location=${u.location}");
            }
          } catch (e) {
            print("❌ Firestore query error: $e");
          }
        } else {
          print("⚠️ No liked IDs found.");
          favouriteUsers.clear();
        }
      } else {
        print("⚠️ User document $currentUserId does not exist.");
      }
    });
  }

}