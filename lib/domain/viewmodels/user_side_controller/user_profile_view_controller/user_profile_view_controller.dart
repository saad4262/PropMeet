import 'package:get/get.dart';
import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../model/user_model/user_model.dart';

class UserProfileViewController extends GetxController {
  final UserProfileRepository _repository = UserProfileRepository();
  double get completion => profile.value?.completionPercentage ?? 0.0;

  var profile = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    profile.value = await _repository.fetchUserProfile();
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      await _repository.updateUserProfile(updatedUser);
      profile.value = updatedUser;
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

}
