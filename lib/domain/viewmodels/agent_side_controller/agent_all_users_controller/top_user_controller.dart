import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../model/user_model/user_model.dart';

class TopUserController extends GetxController {
  final UserProfileRepository repository = UserProfileRepository();

  var users = <UserModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final fetchedUsers = await repository.fetchUsersByTag("user");
      users.assignAll(fetchedUsers);
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
