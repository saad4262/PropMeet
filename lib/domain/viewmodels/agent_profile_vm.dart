// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:propmeet/shared/constants/app_images.dart';

// class ProfileSetupAgent extends GetxController {
//   final int totalPages = 11;

//   var currentPage = 0.obs;
//   late RxList<int?> selections;
//   RxDouble progressPercent = 0.0.obs;
//   var selectedLocation = "Lahore, Punjab Pakistan".obs;
//   var profileImage = Rx<File?>(null);
//   var firstName = "".obs;
//   var lastName = "".obs;
//   var phoneNumber = "".obs;
//   var bio = "".obs;

//   // 🔹 User selected location

//   late RxMap<String, String?> propertyDetails;

//   Future pickProfileImage() async {
//   final ImagePicker picker = ImagePicker();
//   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//   if (image != null) {
//     profileImage.value = File(image.path);
//   }
// }

//   final pagesData = [
//     {
//       "question": "Where’s your property located?",
//       "subQuestion":
//           "We will find the best local agents in your area, Then you can swipe to find the right one for you.",
//     },
//     {
//       "question": "Where’s your property located?",
//       "subQuestion":
//           "We will find the best local agents in your area, Then you can swipe to find the right one for you.",
//     },
//     {
//       "question": "What’s your timeline?",
//       "subQuestion":
//           "This helps us prioritise the most suitable agents and set the right expectations.",
//       "options": [
//         "Just Researching",
//         "Selling in 3-6 Months",
//         "Ready to Sell Now",
//       ],
//       "subOptions": [
//         "Exploring options no rush to sell",
//         "Planning ahead want to prepare",
//         "Terraced or townhouse propertyWant to list property immediately",
//       ],
//       "images": [AppImages.search, AppImages.calender, AppImages.light],
//     },
//     {
//       "question": "A little more about your property.",
//       "subQuestion":
//           "The more details you share, the smarter your agent matches.\nThis helps you connect with the right agents for your property needs. (You can skip this step if you’re not ready. Your profile will still be created.)",
//       "fields": [
//         {
//           "title": "Bedrooms",
//           "options": ["1-2", "3-4", "5-6", "6+"],
//         },
//         {
//           "title": "Bathrooms",
//           "options": ["1-2", "3-4", "4+"],
//         },
//         {
//           "title": "Car Spaces",
//           "options": ["0", "1-2", "3-4", "4+"],
//         },
//         {
//           "title": "Approx. Property Value",
//           "options": ["<\$500K", "\$500K - \$1M", "\$1M - \$2M", "\$2M+"],
//         },
//         {
//           "title": "Land Size",
//           "options": ["<300 sqm", "300 - 600 sqm", "600 - 900 sqm", "900+ sqm"],
//         },
//       ],
//       "note":
//           "Owners who shares more details get matched with better suited agents and receive more tailored response",
//     },
//   ];

//   @override
//   void onInit() {
//     super.onInit();
//     selections = RxList<int?>(List.filled(totalPages, null));
//     // propertyDetails =
//     //     <String, String?>{
//     //       "Bedrooms": null,
//     //       "Bathrooms": null,
//     //       "Car Spaces": null,
//     //       "Approx. Property Value": null,
//     //       "Land Size": null,
//     //     }.obs;
//     propertyDetails = RxMap<String, String?>({
//       "Bedrooms": null,
//       "Bathrooms": null,
//       "Car Spaces": null,
//       "Approx. Property Value": null,
//       "Land Size": null,
//     });
//   }

//   // void setSelection(int pageIndex, int optionIndex) {
//   //   selections[pageIndex] = optionIndex;
//   // }

//   void setSelection(int page, int? value) {
//     selections[page] = value;
//     saveProfileToFirestore(); // auto save on every change
//   }

//   void updatePage(int index) {
//     currentPage.value = index;
//     progressPercent.value = (index + 1) / totalPages;
//   }

//   // Location update
//   // void setLocation(String location) {
//   //   selectedLocation.value = location;
//   // }

//   void setPropertyDetail(String field, String value) {
//     propertyDetails[field] = value;
//     saveProfileToFirestore(); // ✅ auto save on property detail update
//   }

//   void setLocation(String? location) {
//     if (location == null || location.trim().isEmpty) {
//       selectedLocation.value = "Lahore, Punjab Pakistan";
//     } else {
//       selectedLocation.value = location;
//     }
//     saveProfileToFirestore(); // ✅ auto save on location update
//   }

//   Future<void> saveProfileToFirestore() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final userId = user.uid;

//       Map<String, dynamic> profileData = {
//         "selections": List.generate(selections.length, (i) {
//           final index = selections[i];
//           if (index == null) return ""; // agar user ne kuch select nahi kiya

//           final page = pagesData[i];

//           if (page["options"] != null) {
//             final options = page["options"] as List<String>;
//             return options[index]; // ✅ actual option text instead of index
//           }

//           return "";
//         }),

//         "location":
//             selectedLocation.value.isEmpty
//                 ? "Lahore, Punjab Pakistan"
//                 : selectedLocation.value,
//         "propertyDetails": Map<String, dynamic>.from(
//           propertyDetails.map((k, v) => MapEntry(k, v ?? "")),
//         ),
//         "progress": progressPercent.value,
//         "updatedAt": FieldValue.serverTimestamp(),
//       };

//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(userId)
//           .collection("profile_user")
//           .doc("setupData")
//           .set(profileData, SetOptions(merge: true));

//       print("✅ Profile saved successfully with actual options");
//     } catch (e) {
//       print("❌ Error saving profile: $e");
//     }
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propmeet/shared/constants/app_images.dart';

class ProfileSetupController extends GetxController {
  final int totalPages = 11;

  var currentPage = 0.obs;
  RxDouble progress = 0.0.obs;

  // Profile fields
  var profileImage = Rx<File?>(null);
  var firstName = "".obs;
  var lastName = "".obs;
  var phoneNumber = "".obs;
  var bio = "".obs;

  late TextEditingController firstNameController;

  var toggleLeaseRenewal = false.obs;
  var toggleNegotiable = false.obs;

  var fieldData = <String, String>{}.obs;

  // Selections
  // RxList<int?> selections = <int?>[].obs;
  RxList<String?> selections = <String?>[].obs;

  // var selectionsOption1 = <int, String>{}.obs; // Selling Fee -> Option1 group
  // var selectionsOption2 = <int, String>{}.obs; // Selling Fee -> Option2 group

  var selectionsOption1 = <String, String>{}.obs; // question -> selected option
  var selectionsOption2 = <String, String>{}.obs;
  var selection = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    firstNameController = TextEditingController();
    selections = RxList<String?>(List.filled(totalPages, null));
  }

  @override
  void onClose() {
    firstNameController.dispose();
    super.onClose();
  }

  final List<Map<String, dynamic>> pagesData = [
    {
      "type": "profile",
      "heading": "Personal Details",
      "question": " Let’s start with the basics.",
      "subQuestion":
          "Agents with a professional photo get 40% more engagement.",
      "subQuestion2":
          "Tell property owners a little about yourself, this helps build trust and attract more  clients.",
      "fields": [
        {"label": "First Name", "hint": "Enter your first name"},
        {"label": "Last Name", "hint": "Enter your last name"},
        {"label": "Phone Number", "hint": "Enter phone number"},
        {"label": "Bio", "hint": "Write a short bio"},
      ],
    },
    {
      "type": "selection",
      "heading": "Services",
      "question": "What service do you provide to property owners?",
      "subQuestion":
          "Choose the services you offer so we can match you with the right clients.",
      "options": ["Sell Property", "Property Management"],
      "subOptions": [
        "I help property owners sell their property",
        "I help property owners manage rentals",
      ],
      "images": [AppImages.sellAgent, AppImages.propertyAgent],
    },

    // {
    //   "type": "fields",
    //   "heading": "Agent Details ",
    //   "question": "Agency Information",
    //   "subQuestion":
    //       "What professional title would you like displayed on your profile?",
    //   "subQuestion2":
    //       "How many years of experience do you have as a real estate agent?",
    //   "subQuestion3": "How many reviews have you received from clients?",
    //   "subQuestion4": "What is your average rating from all client reviews?",
    //   "fields": [
    //     {"label": "Agency Name", "hint": "Enter your agency name"},
    //     {"label": "License Number", "hint": "Enter license number"},
    //     {"label": "Years of Experience", "hint": "e.g. 5"},
    //   ],
    // },
    {
      "type": "fields",
      "heading": "Agent Details",
      "question": "Agent Information",
      "subQuestion":
          "What professional title would you like displayed on your profile?",
      "subQuestion2":
          "How many years of experience do you have as a real estate agent?",
      "subQuestion3": "How many reviews have you received from clients?",
      "subQuestion4": "What is your average rating from all client reviews?",

      "fields": [
        {
          "label": "Professional Title",
          "hint": "Select title",
          "type": "dropdown",
          "options": [
            "Sales Consultant",
            "Property Sales Specialist",
            "Rental & Leasing  Manager",
            "Principal / Director",
            "Auction Specialist",
          ],
        },
        {"label": "Years of Experience", "hint": "e.g. 10", "type": "text"},
        {"label": "Client Reviews", "hint": "e.g. 50", "type": "text"},
        {"label": "Average Rating", "hint": "e.g. 4.5", "type": "text"},
      ],
    },
    {
      "type": "fields",
      "heading": "Sales History",
      "question": "Location",
      "subQuestion": "How many properties have you sold in the last 12 months?",
      "heading2": "Property Breakdown",
      "subQuestion2":
          "Tell us how many of each property type you’ve sold (this helps match you with the right  sellers):",
      "heading3": "Service Area",

      "fields": [
        {
          "label": "How many properties have you sold in the last 12 months?",
          "hint": "e.g. 150",
        },
        {"label": "House", "hint": "House"},
        {"label": "Land", "hint": "Land"},
        {"label": "Townhouse", "hint": "Townhouse"},
        {"label": "Apartment & Unit", "hint": "Apartment & Unit"},
        {"label": "Luxury Homes", "hint": "Luxury Homes"},
        {"label": "Rural / Acreage", "hint": "Rural / Acreage"},
        {"label": "Off-the-Plan", "hint": "Off-the-Plan"},
        {"label": "Bio", "hint": "Enter your bio here"},
      ],
    },
    {
      "type": "fields",
      "heading": "Performance History",
      "question": "Showcase Your Performance",
      "question2": "Property Management",

      "subQuestion":
          "Sellers want to see results. Share your recent sales performance to boost credibility.",
      "subQuestion2":
          "How many properties have you sold in the last 12 months?",
      "subQuestion3":
          "What was your median days on market (time advertised before sale)?",
      "subQuestion4":
          "How many properties do you currently manage under rental agreements?",
      "fields": [
        {
          "label": "How many properties have you sold in the last 12 months?",
          "hint": "0.00",
        },
        {
          "label":
              "What was your median days on market (time advertised before sale)?",
          "hint": "00 days",
        },
        {
          "label":
              "How many properties do you currently manage under rental agreements?",
          "hint": "e.g. 15",
        },
      ],
    },
    {
      "type": "selection",
      "heading": "Selling Fee",
      "question": "What’s your standard selling fee?",
      "subQuestion":
          "Be transparent, this helps clients compare agents fairly.",
      "question2": "Fee Structure",
      "question3": "Are your fees negotiable?",
      "option1": ["Commission (% of sale price)", "Flat fee (\$ amount)"],
      "option2": ["Yes, open to negotiation", "No, fixed fees"],
      "subOption1": ["Example: 1.8% commission", "Example: \$8,500 flat fee"],
    },
    {
      "type": "fields",
      "heading": "Marketing Fees",
      "question": "What’s your typical marketing package cost?",
      "subQuestion":
          "Most sellers want an idea of what they’ll invest in marketing.",
      "heading2": "Range",
      "fields": [
        {"label": "Min Range", "hint": "\$  0.00 "},
        {"label": "Max range", "hint": "\$  0.00 "},
      ],
    },
    {
      "type": "fields",
      "heading": "Rental Fees",
      "question": "What are your rental management fees?",
      "subQuestion": "What are your rental management fees?",
      "heading2": "Management Fee (% of weekly rent)",
      "heading3": "Letting Fee (new tenant)",
      "heading4": "Advertising Cost Range",

      "fields": [
        {"label": "Management Fee (% of weekly rent)", "hint": "e.g. 7%"},
        {"label": "Letting Fee (new tenant)", "hint": "e.g. 1 week’s rent"},
        {"label": "Advertising Cost Range", "hint": " e.g. \$200 – \$500"},
      ],
    },
    {
      "type": "fields",
      "heading": "Agency Details",
      "question": "Provide your agency details",
      "subQuestion":
          "The more complete your profile, the more trust you build.",
      "heading2": "Agency Name",
      "heading3": "License Number",
      "heading4": "Agency Phone Number",

      "fields": [
        {"label": "Agency Name", "hint": "e.g. Ray White Melbourne"},
        {"label": "License Number", "hint": "e.g., REI-1234"},
        {"label": "Agency Phone Number", "hint": " Enter agency Phone Number"},
      ],
    },
    {
      "type": "fields",
      "heading": "Agency Location",
      "question": "Where’s your agency located?",
      "subQuestion":
          "Your profile will appear to clients searching in and around this area.",
      "heading2": "Enter location",

      "fields": [
        {"label": "Location", "hint": "e.g. Jakarta , Indonesia"},
      ],
    },
    // {
    //   "type": "fields",
    //   "question": "Commission Structure",
    //   "subQuestion": "Provide your commission details",
    //   "fields": [
    //     {"label": "Commission %", "hint": "e.g. 2%"},
    //     {"label": "Other Fees", "hint": "Optional"},
    //   ],
    // },
    // {
    //   "type": "fields",
    //   "question": "Extra Details",
    //   "subQuestion": "Any additional information",
    //   "fields": [
    //     {"label": "Awards", "hint": "List your awards"},
    //     {"label": "Certifications", "hint": "Enter certifications"},
    //   ],
    // },
    {"type": "final"},
  ];

  void updatePage(int index) {
    currentPage.value = index;
    progress.value = (index + 1) / totalPages;
  }

  Future pickProfileImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  Future<String?> uploadProfileImage(File image, String uid) async {
    final ref = FirebaseStorage.instance.ref().child("profile_images/$uid.jpg");

    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  // void setSelection(int page, int value) {
  //   selections[page] = value;
  // }

  // void setSelectionOption1(int page, int value) {
  //   selectionsOption1[page] = value;
  // }

  // void setSelectionOption2(int page, int value) {
  //   selectionsOption2[page] = value;
  // }

  // void setSelection(int pageIndex, String selectedOption) {
  //   final question =
  //       (pagesData[pageIndex]["question"] ?? "Option1 Question $pageIndex")
  //           .toString();
  //   selectionsOption1[question] = selectedOption;
  // }

  // void setSelectionOption1(int page, String value) {
  //   selectionsOption1[page] = value;
  // }

  // void setSelectionOption2(int page, String value) {
  //   selectionsOption2[page] = value;
  // }

  // Update setter functions
  void setSelectionOption1(int pageIndex, String selectedOption) {
    final question =
        (pagesData[pageIndex]["question2"] ?? "Option1 Question $pageIndex")
            .toString();
    selectionsOption1[question] = selectedOption;
  }

  void setSelection(int pageIndex, String selectedOption) {
    final question =
        (pagesData[pageIndex]["question"] ?? "Option1 Question $pageIndex")
            .toString();
    selection[question] = selectedOption;
  }

  void setSelectionOption2(int pageIndex, String selectedOption) {
    final question =
        (pagesData[pageIndex]["question3"] ?? "Option2 Question $pageIndex")
            .toString();
    selectionsOption2[question] = selectedOption;
  }

  Future<void> saveAgentProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        throw Exception("User not logged in");
      }

      String? imageUrl;
      if (profileImage.value != null) {
        imageUrl = await uploadProfileImage(profileImage.value!, uid);
      }

      // prepare final data object
      final data = {
        // "firstName": firstName.value,
        // "lastName": lastName.value,
        // "phoneNumber": phoneNumber.value,
        // "bio": bio.value,
        "profileImage": imageUrl,
        "toggleLeaseRenewal": toggleLeaseRenewal.value,
        "toggleNegotiable": toggleNegotiable.value,
        "fieldData": fieldData,
        // "selections": selections.map((e) => e?.toString()).toList(),
        "selectionsOption1": selectionsOption1.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ),
        "setSelection": selection.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ),
        "selectionsOption2": selectionsOption2.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ),
        "createdAt": FieldValue.serverTimestamp(),
      };

      // save in subcollection agentProfile
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("agentProfile")
          .doc("profile") // fixed doc id
          .set(data, SetOptions(merge: true));

      Get.snackbar("Success", "Agent profile saved successfully!");
      print("✅ Agent profile saved inside Firestore");
    } catch (e) {
      print("❌ Error saving agent profile: $e");
      Get.snackbar("Error", "Failed to save profile: $e");
    }
  }
}
