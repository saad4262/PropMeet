// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
// import '../../../../model/agent_model/agent_model.dart';
//
// class AgentEditProfileViewController extends GetxController {
//   final AgentProfileRepository _repository = AgentProfileRepository();
//
//   var agent = Rxn<AgentFieldData>();
//   var isLoading = false.obs;
//
//   /// Fetch profile
//   Future<void> fetchProfile() async {
//     try {
//       isLoading.value = true;
//       final data = await _repository.fetchAgentProfile();
//       if (data != null) {
//         agent.value = data;
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch profile: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfile();
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../model/agent_model/agent_model.dart';
import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';

class AgentEditProfileViewController extends GetxController {
  final AgentProfileRepository _repo = AgentProfileRepository();

  final isEditing = false.obs;

  final List<String> serviceOptions = ["Sell Property", "Property Management"];
  final List<String> feeOptions = ["No Fee Structure", "Yes Open to Negotiable"];

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final titleController = TextEditingController();
  final bioController = TextEditingController();
  final experienceController = TextEditingController();
  final ratingController = TextEditingController();
  final reviewCountController = TextEditingController();
  final medianDaysController = TextEditingController();
  final managingController = TextEditingController();

  final serviceProvided = "Sell Property".obs;
  final feeStructure = "No Fee Structure".obs;

  final agentData = Rxn<AgentFieldData>(); // ✅ FIXED

  @override
  void onInit() {
    super.onInit();
    fetchAgentData();
  }

  Future<void> fetchAgentData() async {
    final data = await _repo.fetchAgentProfile();
    if (data != null) {
      agentData.value = data;
      _populateControllers(data);
    }
  }

  void _populateControllers(AgentFieldData data) {
    firstNameController.text = data.firstName;
    lastNameController.text = data.lastName;
    titleController.text = data.professionalTitle;
    bioController.text = data.bio;
    experienceController.text = data.yearsOfExperience;
    ratingController.text = data.averageRating;
    reviewCountController.text = data.clientReviews;
    medianDaysController.text = data.medianDaysOnMarket;
    managingController.text = data.managedProperties;

    serviceProvided.value = serviceOptions.contains(data.serviceProvided)
        ? data.serviceProvided
        : serviceOptions.first;

    feeStructure.value = feeOptions.contains(data.feeStructure)
        ? data.feeStructure
        : feeOptions.first;
  }

  void toggleEdit() => isEditing.value = !isEditing.value;

  Future<void> saveProfile() async {
    final data = agentData.value;
    if (data == null) return;

    final updated = data.copyWith(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      title: titleController.text.trim(),
      bio: bioController.text.trim(),
      experience: experienceController.text.trim(),
      rating: ratingController.text.trim(),
      reviewCount: reviewCountController.text.trim(),
      medianDays: medianDaysController.text.trim(),
      managing: managingController.text.trim(),
      serviceProvided: serviceProvided.value,
      feeStructure: feeStructure.value,
    );

    await _repo.updateAgentProfile(updated);
    agentData.value = updated;
    isEditing.value = false;
    Get.snackbar('Success', 'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    titleController.dispose();
    bioController.dispose();
    experienceController.dispose();
    ratingController.dispose();
    reviewCountController.dispose();
    medianDaysController.dispose();
    managingController.dispose();
    super.onClose();
  }
}
