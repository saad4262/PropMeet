// file: domain/viewmodels/user_side_controller/favourites_view_controller/favourite_view_controller.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
import '../../../../model/agent_model/agent_model.dart';

class FavouriteViewController extends GetxController {
  final UserProfileRepository _repo = UserProfileRepository();
  final AgentProfileRepository _agentRepo = AgentProfileRepository();

  var favouriteAgents = <AgentFieldData>[].obs; // holds agents
  var isLoading = false.obs;

  StreamSubscription<QuerySnapshot>? _favsSub;

  @override
  void onInit() {
    super.onInit();
    _listenToFavourites(); // reactive realtime listener
    // Note: fetchFavouriteAgents() is still available if you need a one-time fetch,
    // but we rely on the realtime listener for instant updates.
  }

  @override
  void onClose() {
    _favsSub?.cancel();
    super.onClose();
  }

  /// Optional: keep as a manual one-time fetch (not required if listener is used)
  Future<void> fetchFavouriteAgents() async {
    try {
      isLoading.value = true;
      print("🚀 fetchFavouriteAgents() called");

      final agents = await _repo.fetchFavouriteAgents(); // your existing repo method
      print("📦 Repo returned ${agents.length} favourites");

      favouriteAgents.assignAll(agents.cast<AgentFieldData>());
      print("✅ favouriteAgents updated: ${favouriteAgents.length}");
    } catch (e) {
      print("❌ Error fetching favourite agents: $e");
      favouriteAgents.clear();
    } finally {
      isLoading.value = false;
      print("🏁 fetchFavouriteAgents() finished");
    }
  }

  void _listenToFavourites() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      favouriteAgents.clear();
      return;
    }

    isLoading.value = true;

    _favsSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .snapshots()
        .listen((snap) async {
      try {
        final ids = snap.docs.map((d) => d.id).toList();
        print("🔥 Favourite IDs stream: $ids");

        if (ids.isEmpty) {
          favouriteAgents.clear();
          isLoading.value = false;
          return;
        }

        // Use the new AgentProfileRepository helper to get AgentFieldData objects
        final agents = await _agentRepo.fetchAgentsByIds(ids);
        favouriteAgents.assignAll(agents);
        print("✅ favouriteAgents assigned: ${favouriteAgents.length}");
      } catch (e, st) {
        print("❌ Error listening to favourites: $e\n$st");
        favouriteAgents.clear();
      } finally {
        isLoading.value = false;
      }
    }, onError: (e) {
      print("Snapshot error favourites: $e");
      isLoading.value = false;
    });
  }
}
