import 'package:get/get.dart';

import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
import '../../../../model/agent_model/agent_model.dart';

class AgentProfileViewController extends GetxController{
  final AgentProfileRepository _repository = AgentProfileRepository();

  var profile = Rxn<AgentFieldData>();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();

  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final fetchedProfile = await _repository.fetchAgentProfile();
      profile.value = fetchedProfile;
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(AgentFieldData updatedUser) async {
    try {
      isLoading.value = true;
      await _repository.updateAgentProfile(updatedUser);
      profile.value = updatedUser;
    } catch (e) {
      print("Error updating profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}