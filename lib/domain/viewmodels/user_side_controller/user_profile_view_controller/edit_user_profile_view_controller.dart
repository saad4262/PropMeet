import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../model/user_model/property_detail_model.dart';
import '../../../../model/user_model/user_model.dart';

// class EditUserProfileViewController extends GetxController {
//   final UserProfileRepository _repository = UserProfileRepository();
//
//   var profile = Rxn<UserModel>();
//
//   // Text controllers
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final locationController = TextEditingController();
//
//   var sellChoice = "".obs; // e.g., "Sell my home"
//   var propertyType = "".obs; // e.g., "Townhouse"
//   var timeline = "".obs; // e.g., "3 months"
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadProfile();
//   }
//
//   Future<void> loadProfile() async {
//     profile.value = await _repository.fetchUserProfile();
//
//     if (profile.value != null) {
//       nameController.text = profile.value!.name ?? "";
//       emailController.text = profile.value!.email ?? "";
//       locationController.text = profile.value!.location ?? "";
//
//       // pre-fill choice values if available
//       if (profile.value!.selections.isNotEmpty) {
//         sellChoice.value = profile.value!.selections[0];
//         propertyType.value = profile.value!.selections.length > 1
//             ? profile.value!.selections[1]
//             : "";
//         timeline.value = profile.value!.selections.length > 4
//             ? profile.value!.selections[4]
//             : "";
//       }
//     }
//   }
//
//   Future<void> saveProfile() async {
//     if (profile.value == null) return;
//
//     // Start with existing selections so we don’t lose them
//     final existingSelections = List<String>.from(profile.value!.selections);
//
//     // Ensure it has at least 5 slots
//     while (existingSelections.length < 5) {
//       existingSelections.add("");
//     }
//
//     // Update only the relevant indexes
//     existingSelections[0] = sellChoice.value; // "What do you want to do?"
//     existingSelections[1] = propertyType.value; // "Property type"
//     existingSelections[4] = timeline.value; // "Timeline"
//
//     final updatedUser = profile.value!.copyWith(
//       name: nameController.text,
//       email: emailController.text,
//       location: locationController.text,
//       selections: existingSelections,
//     );
//
//     try {
//       await _repository.updateUserProfile(updatedUser);
//       profile.value = updatedUser;
//       Get.snackbar("Success", "Profile updated successfully ✅");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to update profile: $e");
//     }
//   }
//
//   void updatePropertyDetail(String field, String value) {
//     final updated = profile.value!.propertyDetails.toMap();
//     updated[field] = value;
//
//     profile.value = profile.value!.copyWith(
//       propertyDetails: PropertyDetails.fromMap(updated),
//     );
//
//     saveProfile();
//   }
//
// }
class EditUserProfileViewController extends GetxController {
  final UserProfileRepository _repository = UserProfileRepository();

  var profile = Rxn<UserModel>();

  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();

  // High-level choices
  var sellChoice = "".obs;
  var propertyType = "".obs;
  var timeline = "".obs;

  // 🔹 Property detail selections
  final Map<String, List<String>> fieldOptions = {
    "Approx. Property Value": ["<\$500K", "\$500K - \$1M", "\$1M - \$2M", "\$2M+"],
    "Bedrooms": ["1-2", "3-4", "5-6", "6+"],
    "Bathrooms": ["1-2", "3-4", "4+"],
    "Car Spaces": ["0", "1-2", "3-4", "4+"],
    "Land Size": ["<300 sqm", "300 - 600 sqm", "600 - 900 sqm", "900+ sqm"],
  };

  // Observables for property detail fields
  late Map<String, RxString> propertyDetailsSelections;

  @override
  void onInit() {
    super.onInit();

    // Initialize with empty
    propertyDetailsSelections = {
      for (var field in fieldOptions.keys) field: "".obs,
    };

    loadProfile();
  }

  Future<void> loadProfile() async {
    profile.value = await _repository.fetchUserProfile();

    if (profile.value != null) {
      nameController.text = profile.value!.name ?? "";
      emailController.text = profile.value!.email ?? "";
      locationController.text = profile.value!.location ?? "";

      // Prefill main selections
      if (profile.value!.selections.isNotEmpty) {
        sellChoice.value = profile.value!.selections[0];
        propertyType.value =
        profile.value!.selections.length > 1 ? profile.value!.selections[1] : "";
        timeline.value =
        profile.value!.selections.length > 4 ? profile.value!.selections[4] : "";
      }

      // Prefill property details
      final detailsMap = profile.value!.propertyDetails.toMap();
      detailsMap.forEach((field, value) {
        if (propertyDetailsSelections.containsKey(field)) {
          propertyDetailsSelections[field]!.value = value;
        }
      });
    }
  }

  Future<void> saveProfile() async {
    if (profile.value == null) return;

    final existingSelections = List<String>.from(profile.value!.selections);
    while (existingSelections.length < 5) {
      existingSelections.add("");
    }

    existingSelections[0] = sellChoice.value;
    existingSelections[1] = propertyType.value;
    existingSelections[4] = timeline.value;

    // 🔹 Gather property details
    final updatedDetails = {
      for (var entry in propertyDetailsSelections.entries) entry.key: entry.value.value
    };

    final updatedUser = profile.value!.copyWith(
      name: nameController.text,
      email: emailController.text,
      location: locationController.text,
      selections: existingSelections,
      propertyDetails: PropertyDetails.fromMap(updatedDetails),
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
    if (propertyDetailsSelections.containsKey(field)) {
      propertyDetailsSelections[field]!.value = value;
    }
  }
}
