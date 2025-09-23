import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../model/user_model/property_detail_model.dart';
import '../../../../model/user_model/user_model.dart';

class EditUserProfileViewController extends GetxController {
  final UserProfileRepository _repository = UserProfileRepository();

  var profile = Rxn<UserModel>();

  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();

  var sellChoice = "".obs; // e.g., "Sell my home"
  var propertyType = "".obs; // e.g., "Townhouse"
  var timeline = "".obs; // e.g., "3 months"

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    profile.value = await _repository.fetchUserProfile();

    if (profile.value != null) {
      nameController.text = profile.value!.name ?? "";
      emailController.text = profile.value!.email ?? "";
      locationController.text = profile.value!.location ?? "";

      // pre-fill choice values if available
      if (profile.value!.selections.isNotEmpty) {
        sellChoice.value = profile.value!.selections[0];
        propertyType.value = profile.value!.selections.length > 1
            ? profile.value!.selections[1]
            : "";
        timeline.value = profile.value!.selections.length > 4
            ? profile.value!.selections[4]
            : "";
      }
    }
  }

  Future<void> saveProfile() async {
    if (profile.value == null) return;

    // Start with existing selections so we don’t lose them
    final existingSelections = List<String>.from(profile.value!.selections);

    // Ensure it has at least 5 slots
    while (existingSelections.length < 5) {
      existingSelections.add("");
    }

    // Update only the relevant indexes
    existingSelections[0] = sellChoice.value; // "What do you want to do?"
    existingSelections[1] = propertyType.value; // "Property type"
    existingSelections[4] = timeline.value; // "Timeline"

    final updatedUser = profile.value!.copyWith(
      name: nameController.text,
      email: emailController.text,
      location: locationController.text,
      selections: existingSelections,
    );

    try {
      await _repository.updateUserProfile(updatedUser);
      profile.value = updatedUser;
      Get.snackbar("Success", "Profile updated successfully ✅");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    }
  }

  void updatePropertyDetail(String field, String value) {
    final updated = profile.value!.propertyDetails.toMap();
    updated[field] = value;

    profile.value = profile.value!.copyWith(
      propertyDetails: PropertyDetails.fromMap(updated),
    );

    saveProfile();
  }

}
