import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
import '../../../../model/agent_model/agent_model.dart';

class AgentEditProfileViewController extends GetxController {
  final AgentProfileRepository _repository = AgentProfileRepository();

  var agent = Rxn<AgentFieldData>();
  var isLoading = false.obs;

  /// Fetch profile
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await _repository.fetchAgentProfile();
      if (data != null) {
        agent.value = data;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }
}
