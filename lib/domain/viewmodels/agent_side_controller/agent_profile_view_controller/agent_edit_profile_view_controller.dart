// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../../../model/agent_model/agent_model.dart';
// import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
// import '../../../../model/mapmodel/map_model.dart' as gmaps;
//
// class AgentEditProfileViewController extends GetxController {
//   final AgentProfileRepository _repo = AgentProfileRepository();
//
//   final isEditing = false.obs;
//
//   final List<String> serviceOptions = ["Sell Property", "Property Management"];
//   final List<String> feeOptions = ["No Fee Structure", "Yes Open to Negotiable"];
//
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final titleController = TextEditingController();
//   final bioController = TextEditingController();
//   final experienceController = TextEditingController();
//   final ratingController = TextEditingController();
//   final reviewCountController = TextEditingController();
//   final medianDaysController = TextEditingController();
//   final managingController = TextEditingController();
//   final locationController = TextEditingController();
//
//
//   final serviceProvided = "Sell Property".obs;
//   final feeStructure = "No Fee Structure".obs;
//
//   final agentData = Rxn<AgentFieldData>();
//
//
//   final selectedPlaceDetails = Rxn<gmaps.PlaceDetails>();
//   final selectedLocation = Rxn<LatLng>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAgentData();
//   }
//
//   Future<void> fetchAgentData() async {
//     final data = await _repo.fetchAgentProfile();
//     if (data != null) {
//       agentData.value = data;
//       _populateControllers(data);
//     }
//   }
//
//   void _populateControllers(AgentFieldData data) {
//     firstNameController.text = data.firstName;
//     lastNameController.text = data.lastName;
//     titleController.text = data.professionalTitle;
//     bioController.text = data.bio;
//     locationController.text = data.location ?? '--';
//     experienceController.text = data.yearsOfExperience;
//     ratingController.text = data.averageRating;
//     reviewCountController.text = data.clientReviews;
//     medianDaysController.text = data.medianDaysOnMarket;
//     managingController.text = data.managedProperties;
//
//     serviceProvided.value = serviceOptions.contains(data.serviceProvided)
//         ? data.serviceProvided
//         : serviceOptions.first;
//
//     feeStructure.value = feeOptions.contains(data.feeStructure)
//         ? data.feeStructure
//         : feeOptions.first;
//   }
//
//   void toggleEdit() => isEditing.value = !isEditing.value;
//
//   Future<void> saveProfile() async {
//     final data = agentData.value;
//     if (data == null) return;
//
//     final updated = data.copyWith(
//       firstName: firstNameController.text.trim(),
//       lastName: lastNameController.text.trim(),
//       title: titleController.text.trim(),
//       bio: bioController.text.trim(),
//       // location: locationController.text.trim(),
//       location: selectedPlaceDetails.value?.address ?? locationController.text.trim(),
//       experience: experienceController.text.trim(),
//       rating: ratingController.text.trim(),
//       reviewCount: reviewCountController.text.trim(),
//       medianDays: medianDaysController.text.trim(),
//       managing: managingController.text.trim(),
//       serviceProvided: serviceProvided.value,
//       feeStructure: feeStructure.value,
//     );
//
//     await _repo.updateAgentProfile(updated);
//     agentData.value = updated;
//     isEditing.value = false;
//     Get.snackbar('Success', 'Profile updated successfully',
//         snackPosition: SnackPosition.BOTTOM);
//   }
//
//   @override
//   void onClose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     titleController.dispose();
//     bioController.dispose();
//     locationController.dispose();
//     experienceController.dispose();
//     ratingController.dispose();
//     reviewCountController.dispose();
//     medianDaysController.dispose();
//     managingController.dispose();
//     super.onClose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../model/agent_model/agent_model.dart';
import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
import '../../../../model/mapmodel/map_model.dart' as gmaps;

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
  final locationController = TextEditingController();

  final serviceProvided = "Sell Property".obs;
  final feeStructure = "No Fee Structure".obs;

  final agentData = Rxn<AgentFieldData>();
  final selectedPlaceDetails = Rxn<gmaps.PlaceDetails>();
  final selectedLocation = Rxn<LatLng>();

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

    // ✅ Handle location safely (new map or old string)
    final loc = data.location;
    if (loc != null) {
      if (loc is Map && loc.containsKey('address')) {
        locationController.text = loc['address'] ?? '--';
      } else if (loc is String) {
        locationController.text = loc as String;
      }
    } else {
      locationController.text = '--';
    }

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

    // ✅ Build updated location map
    Map<String, dynamic>? updatedLocation;
    if (selectedPlaceDetails.value != null) {
      updatedLocation = {
        "address": selectedPlaceDetails.value!.address,
        "latitude": selectedPlaceDetails.value!.lat,
        "longitude": selectedPlaceDetails.value!.lng,
      };
    } else {
      updatedLocation = data.location; // keep old
    }

    final updated = data.copyWith(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      title: titleController.text.trim(),
      bio: bioController.text.trim(),
      location: updatedLocation,
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
    locationController.dispose();
    experienceController.dispose();
    ratingController.dispose();
    reviewCountController.dispose();
    medianDaysController.dispose();
    managingController.dispose();
    super.onClose();
  }
}
