import 'package:get/get.dart';
import 'package:propmeet/model/agent_model/agent_model.dart';
import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';

class TopAgentViewController extends GetxController {
  final AgentProfileRepository _repo = AgentProfileRepository();

  var agents = <AgentFieldData>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgents();
  }

  Future<void> fetchAgents() async {
    try {
      isLoading.value = true;
      final result = await _repo.fetchAllAgents();
      agents.assignAll(result);
    } catch (e) {
      print("Error fetching agents: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
