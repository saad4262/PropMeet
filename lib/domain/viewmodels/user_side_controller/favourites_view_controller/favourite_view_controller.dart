import 'package:get/get.dart';

import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../model/agent_model/agent_model.dart';

class FavouriteViewController extends GetxController {
  final UserProfileRepository _repo = UserProfileRepository();

  var favouriteAgents = <AgentFieldData>[].obs; // holds agents
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavouriteAgents();
  }

  Future<void> fetchFavouriteAgents() async {
    try {
      isLoading.value = true;
      print("🚀 fetchFavouriteAgents() called");

      // fetch favourites from repo
      final agents = await _repo.fetchFavouriteAgents();
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

}
