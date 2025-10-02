import 'package:get/get.dart';
import 'package:propmeet/data/repositories/agent_side_repository/agent_side_home_repo.dart';
import 'package:propmeet/model/user_model/user_model.dart';

class AgentFavouriteViewController extends GetxController {
  final AgentSideHomeRepo repo = AgentSideHomeRepo();

  /// Store full user objects instead of just IDs
  final RxList<UserModel> favouriteUsers = <UserModel>[].obs;

  Future<void> loadFavourites(String agentId) async {
    try {
      final favIds = await repo.fetchFavourites(agentId);

      final users = await repo.fetchUsersByIds(favIds);

      favouriteUsers.assignAll(users);
    } catch (e) {
      print("Error loading favourites: $e");
    }
  }
}
