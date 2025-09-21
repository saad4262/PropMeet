import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:propmeet/shared/constants/app_images.dart';

class ProfileSetup extends GetxController {
  final int totalPages = 6;

  var currentPage = 0.obs;
  late RxList<int?> selections;
  RxDouble progressPercent = 0.0.obs;
  var selectedLocation = "Lahore, Punjab Pakistan".obs;

  // 🔹 User selected location

  late RxMap<String, String?> propertyDetails;

  final pagesData = [
    {
      "tags": ["Sell", "Rent"],
      "question": "What are you looking to do?",
      "subQuestion":
          "Let us know your property goals so we can match you with the best agents",
      "options": ["Sell My Home", "Rent My Property"],
      "subOptions": [
        "Find agents to help sell your property",
        "Connect with rental management agents",
      ],
      "images": [AppImages.sell, AppImages.rent],
    },
    {
      "question": "What type of property is it ?",
      "subQuestion":
          "This helps us match you with agents who specialise in your property type.",
      "options": ["Home", "Apartment", "Townhouse", "Land"],
      "subOptions": [
        "Detached or semi-detached home",
        "Unit flat or apartment",
        "Terraced or townhouse property",
        "Vacant Land or development site",
      ],
      "images": [
        AppImages.home,
        AppImages.appartment,
        AppImages.townhouse,
        AppImages.land,
      ],
    },
    {
      "question": "Where’s your property located?",
      "subQuestion":
          "We will find the best local agents in your area, Then you can swipe to find the right one for you.",
    },
    {
      "question": "Where’s your property located?",
      "subQuestion":
          "We will find the best local agents in your area, Then you can swipe to find the right one for you.",
    },
    {
      "question": "What’s your timeline?",
      "subQuestion":
          "This helps us prioritise the most suitable agents and set the right expectations.",
      "options": [
        "Just Researching",
        "Selling in 3-6 Months",
        "Ready to Sell Now",
      ],
      "subOptions": [
        "Exploring options no rush to sell",
        "Planning ahead want to prepare",
        "Terraced or townhouse propertyWant to list property immediately",
      ],
      "images": [AppImages.search, AppImages.calender, AppImages.light],
    },
    {
      "question": "A little more about your property.",
      "subQuestion":
          "The more details you share, the smarter your agent matches.\nThis helps you connect with the right agents for your property needs. (You can skip this step if you’re not ready. Your profile will still be created.)",
      "fields": [
        {
          "title": "Bedrooms",
          "options": ["1-2", "3-4", "5-6", "6+"],
        },
        {
          "title": "Bathrooms",
          "options": ["1-2", "3-4", "4+"],
        },
        {
          "title": "Car Spaces",
          "options": ["0", "1-2", "3-4", "4+"],
        },
        {
          "title": "Approx. Property Value",
          "options": ["<\$500K", "\$500K - \$1M", "\$1M - \$2M", "\$2M+"],
        },
        {
          "title": "Land Size",
          "options": ["<300 sqm", "300 - 600 sqm", "600 - 900 sqm", "900+ sqm"],
        },
      ],
      "note":
          "Owners who shares more details get matched with better suited agents and receive more tailored response",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    selections = RxList<int?>(List.filled(totalPages, null));
    // propertyDetails =
    //     <String, String?>{
    //       "Bedrooms": null,
    //       "Bathrooms": null,
    //       "Car Spaces": null,
    //       "Approx. Property Value": null,
    //       "Land Size": null,
    //     }.obs;
    propertyDetails = RxMap<String, String?>({
      "Bedrooms": null,
      "Bathrooms": null,
      "Car Spaces": null,
      "Approx. Property Value": null,
      "Land Size": null,
    });
  }

  // void setSelection(int pageIndex, int optionIndex) {
  //   selections[pageIndex] = optionIndex;
  // }

  void setSelection(int page, int? value) {
    selections[page] = value;
    saveProfileToFirestore(); // auto save on every change
  }

  void updatePage(int index) {
    currentPage.value = index;
    progressPercent.value = (index + 1) / totalPages;
  }

  // Location update
  // void setLocation(String location) {
  //   selectedLocation.value = location;
  // }

  void setPropertyDetail(String field, String value) {
    propertyDetails[field] = value;
    saveProfileToFirestore(); // ✅ auto save on property detail update
  }

  void setLocation(String? location) {
    if (location == null || location.trim().isEmpty) {
      selectedLocation.value = "Lahore, Punjab Pakistan";
    } else {
      selectedLocation.value = location;
    }
    saveProfileToFirestore(); // ✅ auto save on location update
  }

  Future<void> saveProfileToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;

      Map<String, dynamic> profileData = {
        "selections": List.generate(selections.length, (i) {
          final index = selections[i];
          if (index == null) return ""; // agar user ne kuch select nahi kiya

          final page = pagesData[i];

          if (page["options"] != null) {
            final options = page["options"] as List<String>;
            return options[index]; // ✅ actual option text instead of index
          }

          return "";
        }),

        "location":
            selectedLocation.value.isEmpty
                ? "Lahore, Punjab Pakistan"
                : selectedLocation.value,
        "propertyDetails": Map<String, dynamic>.from(
          propertyDetails.map((k, v) => MapEntry(k, v ?? "")),
        ),
        "progress": progressPercent.value,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("profile_setup")
          .doc("setupData")
          .set(profileData, SetOptions(merge: true));

      print("✅ Profile saved successfully with actual options");
    } catch (e) {
      print("❌ Error saving profile: $e");
    }
  }
}
