
import 'dart:io';import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/agent_profile_vm.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class AgentProfile extends StatelessWidget {
  final ProfileSetupController controller = Get.put(ProfileSetupController());
  final PageController pageController = PageController();

  AgentProfile({super.key});

  bool validatePage(int pageIndex) {
    final page = controller.pagesData[pageIndex];

    switch (page["type"]) {
      case "profile":
        return controller.firstName.value.isNotEmpty &&
            controller.lastName.value.isNotEmpty &&
            controller.phoneNumber.value.isNotEmpty &&
            controller.bio.value.isNotEmpty &&
            controller.profileImage.value != null;

      case "selection":
        return controller.selections[pageIndex] != null;

      case "fields":
        for (var field in page["fields"]) {
          final key = field["label"];
          if ((controller.fieldData[key] ?? "").isEmpty) {
            return false;
          }
        }
        return true;

      case "final":
        return true;

      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Profile Setup")),
      body: Column(
        children: [
          SizedBox(height: Responsive.height(5)),

          Obx(
                () => Text(
              controller.pagesData[controller.currentPage.value]["heading"] ??
                  "Profile Setup",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: Responsive.fontSize(6.5),
                color: AppColors.blueMain,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Progress bar
          Padding(
            padding: EdgeInsets.all(Responsive.padding(5)),
            child: Obx(
                  () => LinearProgressIndicator(
                value: controller.progress.value,
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
              ),
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.pagesData.length,
              onPageChanged: (i) => controller.updatePage(i),
              itemBuilder: (context, index) {
                final page = controller.pagesData[index];
                switch (page["type"]) {
                  case "profile":
                    return buildProfilePage(page);
                  case "selection":
                    if (index == 5) {
                      return buildSelectionPage2(index, page);
                    } else {
                      return buildSelectionPage(index, page);
                    }
                  case "fields":
                    if (index == 2) {
                      return buildFieldPage2(page);
                    } else if (index == 3) {
                      return buildFieldPage3(page);
                    } else if (index == 4) {
                      return buildFieldPage4(page);
                    } else if (index == 6) {
                      return buildFieldPage5(page);
                    } else if (index == 7) {
                      return buildFieldPage6(
                        page,
                        controller.toggleLeaseRenewal,
                        controller.toggleNegotiable,
                      );
                    } else if (index == 8) {
                      return buildFieldPage7(page);
                    } else if (index == 9) {
                      return buildFieldPage8(page);
                    } else {
                      return buildFieldPage(
                        page,
                      ); // 👈 baaki pages pe normal buildFieldPage
                    }
                  case "final":
                    return buildFinalPage(page);
                  default:
                    return const Center(child: Text("Unknown Page"));
                }
              },
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Row(
          //     children: [
          //       if (controller.currentPage.value > 0)
          //         Expanded(
          //           child: ElevatedButton(
          //             onPressed: () {
          //               pageController.previousPage(
          //                 duration: const Duration(milliseconds: 300),
          //                 curve: Curves.easeInOut,
          //               );
          //             },
          //             child: const Text("Back"),
          //           ),
          //         ),
          //       const SizedBox(width: 10),
          //       Expanded(
          //         child: Obx(
          //           () => ElevatedButton(
          //             onPressed: () {
          //               // if (controller.currentPage.value <
          //               //     controller.pagesData.length - 1) {
          //               //   pageController.nextPage(
          //               //     duration: const Duration(milliseconds: 300),
          //               //     curve: Curves.easeInOut,
          //               //   );
          //               // } else {
          //               //   Get.snackbar("Success", "Profile Setup Completed!");
          //               // }

          //               if (controller.currentPage.value ==
          //                   controller.pagesData.length - 1) {
          //                 controller.saveAgentProfile(); // ✅ Firestore save
          //               } else {
          //                 pageController.nextPage(
          //                   duration: const Duration(milliseconds: 300),
          //                   curve: Curves.easeInOut,
          //                 );
          //               }
          //             },
          //             child: Text(
          //               controller.currentPage.value ==
          //                       controller.pagesData.length - 1
          //                   ? "Finish"
          //                   : "Next",
          //             ),
          //           ),
          //         ),
          //       ),

          // Expanded(
          //   child: Obx(() {
          //     final isValid = validatePage(controller.currentPage.value);
          //     return ElevatedButton(
          //       onPressed:
          //           isValid
          //               ? () {
          //                 if (controller.currentPage.value <
          //                     controller.pagesData.length - 1) {
          //                   pageController.nextPage(
          //                     duration: const Duration(milliseconds: 300),
          //                     curve: Curves.easeInOut,
          //                   );
          //                 } else {
          //                   controller
          //                       .saveAgentProfile(); // 👈 DB me save kare
          //                   Get.snackbar(
          //                     "Success",
          //                     "Profile Setup Completed!",
          //                   );
          //                 }
          //               }
          //               : null, // 👈 disable button
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor:
          //             isValid ? Colors.blue : Colors.grey, // disable look
          //       ),
          //       child: Text(
          //         controller.currentPage.value ==
          //                 controller.pagesData.length - 1
          //             ? "Finish"
          //             : "Next",
          //       ),
          //     );
          //   }),
          // ),
          //     ],
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                    () =>
                controller.currentPage.value > 0
                    ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Responsive.radius(10),
                      ),
                      border: Border.all(color: AppColors.blueMain),
                    ),
                    width: Responsive.width(40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          fontFamily: "poppins",
                          fontWeight: FontWeight.bold,
                          color: AppColors.blueMain,
                        ),
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                      () => Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(10),
                        ),
                      ),
                      width: Responsive.width(40),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          AppColors.blueMain, // ✅ Button ka apna color

                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // if (controller.currentPage.value <
                          //     controller.pagesData.length - 1) {
                          //   pageController.nextPage(
                          //     duration: const Duration(milliseconds: 300),
                          //     curve: Curves.easeInOut,
                          //   );
                          // } else {
                          //   Get.snackbar("Success", "Profile Setup Completed!");
                          // }

                          if (controller.currentPage.value ==
                              controller.pagesData.length - 1) {
                            controller.saveAgentProfile(); // ✅ Firestore save
                            Get.offAllNamed(AppRoutes.home);
                          } else {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          controller.currentPage.value ==
                              controller.totalPages - 1
                              ? "Finish"
                              : "Continue",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------
  // Profile Page

  Widget buildProfilePage(Map<String, dynamic> page) {
    final fields = page["fields"] as List<dynamic>; // 👈 yahan se fields le lo

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            page["question"],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            page["subQuestion"],
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),

          /// Profile Image
          Center(
            child: Obx(
                  () => GestureDetector(
                onTap: controller.pickProfileImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 60,
                      backgroundImage:
                      controller.profileImage.value != null
                          ? FileImage(controller.profileImage.value!)
                          : null,
                      child:
                      controller.profileImage.value == null
                          ? SvgPicture.asset(AppImages.profile)
                          : null,
                    ),
                    const Positioned(
                      right: 5,
                      bottom: 8,
                      child: Icon(Icons.camera_alt_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// First Name + Last Name Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  // onChanged: (val) => controller.firstName.value = val,
                  onChanged: (val) {
                    // controller.firstName.value = val;
                    controller.fieldData[fields[0]["label"]] = val;
                  },
                  controller: controller.firstNameController,

                  decoration: InputDecoration(
                    hintText: "First Name",
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.grey,
                      fontSize: Responsive.fontSize(4),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Responsive.screenWidth * 0.08,
                      vertical: Responsive.screenHeight * 0.02,
                    ),

                    filled: true,
                    fillColor: AppColors.lightgrey,

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.bordergrey,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: (val) {
                    // controller.lastName.value = val;
                    controller.fieldData[fields[1]["label"]] = val;
                  },
                  decoration: InputDecoration(
                    hintText: "Last Name",
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.grey,
                      fontSize: Responsive.fontSize(4),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Responsive.screenWidth * 0.08,
                      vertical: Responsive.screenHeight * 0.02,
                    ),

                    filled: true,
                    fillColor: AppColors.lightgrey,

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.bordergrey,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Phone Number
          /// Phone Number
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: Responsive.radius(14),
                width: Responsive.radius(14),
                decoration: BoxDecoration(
                  color: AppColors.lightgrey,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.phone,
                    height: Responsive.height(3.5),
                    width: Responsive.width(3.5),
                  ),
                ),
              ),
              const SizedBox(width: 10), // thoda gap
              Expanded(
                // 👈 yeh important hai
                child: TextField(
                  // onChanged: (val) => controller.phoneNumber.value = val,
                  onChanged: (val) {
                    // controller.lastName.value = val;
                    controller.fieldData[fields[2]["label"]] = val;
                  },
                  keyboardType: TextInputType.phone, // 👈 number keypad
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.grey,
                      fontSize: Responsive.fontSize(4),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Responsive.screenWidth * 0.08,
                      vertical: Responsive.screenHeight * 0.02,
                    ),
                    filled: true,
                    fillColor: AppColors.lightgrey,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.bordergrey,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Bio Question
          Text(
            page["subQuestion2"],
            style: TextStyle(
              fontSize: Responsive.fontSize(3.5),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          /// Bio Field
          TextField(
            // onChanged: (val) => controller.bio.value = val,
            onChanged: (val) {
              // controller.lastName.value = val;
              controller.fieldData[fields[3]["label"]] = val;
            },
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Enter service area",
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.grey,
                fontSize: Responsive.fontSize(4),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: Responsive.screenWidth * 0.08,
                vertical: Responsive.screenHeight * 0.02,
              ),

              filled: true,
              fillColor: AppColors.lightgrey,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------
  // Selection Page

  Widget buildSelectionPage(int pageIndex, Map<String, dynamic> page) {
    final options = List<String>.from(page["options"]);
    final subOptions =
    page["subOptions"] != null
        ? List<String>.from(page["subOptions"])
        : null;
    final images =
    page["images"] != null ? List<String>.from(page["images"]) : null;
    final tags = page["tags"] != null ? List<String>.from(page["tags"]) : null;
    final question1 =
    (page["question"] ?? "Option1 Question $pageIndex").toString();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Responsive.padding(2.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Question
          Obx(
                () => Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.padding(3)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hi ${controller.fieldData["First Name"] ?? "No name entered"}",
                  style: TextStyle(
                    fontSize: Responsive.fontSize(5),
                    fontWeight: FontWeight.bold,
                    color: AppColors.blueMain,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.padding(2.5)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                page["question"],
                style: TextStyle(
                  fontSize: Responsive.fontSize(5),
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),

          SizedBox(height: Responsive.height(2)),

          // 🔹 SubQuestion
          if (page["subQuestion"] != null)
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.padding(2.5),
                right: Responsive.padding(9),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  page["subQuestion"],
                  style: TextStyle(
                    fontSize: Responsive.fontSize(3.3),
                    color: AppColors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),

          const SizedBox(height: 30),

          // 🔹 Options (with tags, images, subOptions)
          Obx(() {
            return Column(
              children: List.generate(options.length, (i) {
                // final isSelected = controller.selections[pageIndex] == i;
                final isSelected =
                    controller.selection[question1] == options[i];

                return GestureDetector(
                  onTap: () => controller.setSelection(pageIndex, options[i]),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.white,
                      border: Border.all(
                        color:
                        isSelected ? Colors.blue : AppColors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // 🔹 Tag + Circle radio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (tags != null && i < tags.length)
                              Text(
                                tags[i],
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(4.5),
                                  color: AppColors.grey.shade700,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            const Spacer(),
                            Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                  isSelected
                                      ? AppColors.lightBlue
                                      : AppColors.grey,
                                  width: 2,
                                ),
                                color: AppColors.lightgrey,
                              ),
                              child:
                              isSelected
                                  ? Center(
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lightBlue,
                                  ),
                                ),
                              )
                                  : null,
                            ),
                          ],
                        ),

                        SizedBox(height: Responsive.height(3)),

                        // 🔹 Image + option text + subOption
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (images != null && i < images.length)
                              SvgPicture.asset(
                                images[i],
                                height: Responsive.height(4),
                                width: Responsive.width(4),
                              ),

                            if (images != null) const SizedBox(width: 10),
                            SizedBox(width: Responsive.width(5)),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    options[i],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (subOptions != null &&
                                      i < subOptions.length)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        subOptions[i],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color:
                                          isSelected
                                              ? Colors.blueGrey
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget buildSelectionPage2(int pageIndex, Map<String, dynamic> page) {
    final option1 = List<String>.from(page["option1"] ?? []);
    final option2 = List<String>.from(page["option2"] ?? []);
    final subOption1 = List<String>.from(page["subOption1"] ?? []);
    final question1 = page["question2"] ?? "Option1 Question $pageIndex";
    final question2 = page["question3"] ?? "Option2 Question $pageIndex";

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Responsive.padding(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Question 1
          Text(
            page["question"],
            style: TextStyle(
              fontSize: Responsive.fontSize(5),
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: Responsive.height(2)),

          // 🔹 SubQuestion
          if (page["subQuestion"] != null)
            Text(
              page["subQuestion"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3.3),
                color: AppColors.black,
                fontFamily: 'Poppins',
              ),
            ),

          const SizedBox(height: 25),

          // 🔹 Question 2
          if (page["question2"] != null)
            Text(
              page["question2"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4.5),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: 'Poppins',
              ),
            ),

          SizedBox(height: Responsive.height(1)),

          // 🔹 Option1 with SubOption1
          Obx(() {
            return Column(
              children: List.generate(option1.length, (i) {
                // final isSelected = controller.selectionsOption1[pageIndex] == i;
                // final isSelected =
                //     controller.selectionsOption1[pageIndex] == option1[i];
                final isSelected =
                    controller.selectionsOption1[question1] == option1[i];

                return GestureDetector(
                  // onTap: () => controller.setSelectionOption1(pageIndex, i),
                  onTap:
                      () =>
                      controller.setSelectionOption1(pageIndex, option1[i]),

                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.white,
                      border: Border.all(
                        color:
                        isSelected ? Colors.blue : AppColors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Option text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // if (tags != null && i < tags.length)
                            //   Text(
                            //     tags[i],
                            //     style: TextStyle(
                            //       fontSize: Responsive.fontSize(4.5),
                            //       color: AppColors.grey.shade700,
                            //     ),
                            //   )
                            // else
                            //   const SizedBox.shrink(),
                            const Spacer(),
                            Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                  isSelected
                                      ? AppColors.lightBlue
                                      : AppColors.grey,
                                  width: 2,
                                ),
                                color: AppColors.lightgrey,
                              ),
                              child:
                              isSelected
                                  ? Center(
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lightBlue,
                                  ),
                                ),
                              )
                                  : null,
                            ),
                          ],
                        ),

                        SizedBox(height: Responsive.height(3)),
                        Text(
                          option1[i],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // SubOption1
                        if (i < subOption1.length)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              subOption1[i],
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                isSelected
                                    ? Colors.blueGrey
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),

          const SizedBox(height: 30),

          // 🔹 Question 3
          if (page["question3"] != null)
            Text(
              page["question3"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4.5),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: 'Poppins',
              ),
            ),

          const SizedBox(height: 15),

          // 🔹 Option2
          Obx(() {
            return Column(
              children: List.generate(option2.length, (i) {
                // final isSelected =
                //     controller.selectionsOption2[pageIndex] == option2[i];
                final isSelected =
                    controller.selectionsOption2[question2] == option2[i];

                return GestureDetector(
                  onTap:
                      () =>
                      controller.setSelectionOption2(pageIndex, option2[i]),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.white,
                      border: Border.all(
                        color:
                        isSelected ? Colors.blue : AppColors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Spacer(),
                            Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                  isSelected
                                      ? AppColors.lightBlue
                                      : AppColors.grey,
                                  width: 2,
                                ),
                                color: AppColors.lightgrey,
                              ),
                              child:
                              isSelected
                                  ? Center(
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.lightBlue,
                                  ),
                                ),
                              )
                                  : null,
                            ),
                          ],
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            option2[i],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  // -------------------
  // Field Page
  Widget buildFieldPage(Map<String, dynamic> page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            page["question"],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...page["fields"].map<Widget>((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: field["label"],
                  hintText: field["hint"],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildFieldPage2(Map<String, dynamic> page) {
    final subQuestions = [
      page["subQuestion2"],
      page["subQuestion3"],
      page["subQuestion4"],
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading or main question
          // Text(
          //   page["question"],
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          SizedBox(height: Responsive.height(1)),

          // SubQuestion (if exists)
          if (page["subQuestion"] != null)
            Text(
              page["subQuestion"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3.3),
                color: AppColors.black,
                fontFamily: 'Poppins',
              ),
            ),

          SizedBox(height: Responsive.height(3)),

          // Loop through fields
          ...page["fields"].asMap().entries.map<Widget>((entry) {
            final index = entry.key;
            final field = entry.value;
            final subQ =
            subQuestions.length > index ? subQuestions[index] : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (field["type"] == "dropdown")
                  Obx(() {
                    final options = List<String>.from(field["options"]);
                    final selected =
                        controller.fieldData[field["label"]] ?? options.first;

                    return DropdownButtonFormField2<String>(
                      isExpanded: true,
                      value: selected,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                      items:
                      options
                          .map(
                            (opt) => DropdownMenuItem(
                          value: opt,
                          child: Text(
                            opt,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (val) {
                        controller.fieldData[field["label"]] = val ?? "";
                      },
                      decoration: InputDecoration(
                        hintText: field["hint"],
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.grey,
                          fontSize: Responsive.fontSize(4),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Responsive.screenWidth * 0.08,
                          vertical: Responsive.screenHeight * 0.02,
                        ),
                        filled: true,
                        fillColor: AppColors.lightgrey,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppColors.bordergrey,
                            width: 2,
                          ),
                        ),
                      ),

                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color:
                          AppColors
                              .lightgrey, // 👈 menu ka background yahan change karein
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    );
                  })
                else
                  TextField(
                    onChanged:
                        (val) => controller.fieldData[field["label"]] = val,
                    decoration: InputDecoration(
                      hintText: field["hint"],
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.grey,
                        fontSize: Responsive.fontSize(4),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Responsive.screenWidth * 0.08,
                        vertical: Responsive.screenHeight * 0.02,
                      ),
                      filled: true,
                      fillColor: AppColors.lightgrey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.bordergrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: Responsive.height(.4)),

                // Show subQuestion for this field
                if (subQ != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 16),
                    child: Text(
                      subQ,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(3.3),
                        color: AppColors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildFieldPage3(Map<String, dynamic> page) {
    final fields = page["fields"];

    final subQuestions = [
      page["subQuestion"],
      page["subQuestion2"],
      page["subQuestion3"],
      page["subQuestion4"],
    ];

    final subHeadings = [page["heading2"], page["heading3"]];

    // 🔹 reusable textfield builder
    Widget buildTextField(Map<String, dynamic> f) => TextField(
      onChanged: (val) => controller.fieldData[f["label"]] = val,
      decoration: InputDecoration(
        hintText: f["hint"],
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.grey,
          fontSize: Responsive.fontSize(4),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Responsive.screenWidth * 0.08,
          vertical: Responsive.screenHeight * 0.02,
        ),
        filled: true,
        fillColor: AppColors.lightgrey,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
        ),
      ),
    );

    List<Widget> fieldWidgets = [];

    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      final isFirst = i == 0;
      final isLast = i == fields.length - 1;

      // 🔹 Pehla field (single)
      if (isFirst) {
        fieldWidgets.add(buildTextField(field));
        fieldWidgets.add(SizedBox(height: Responsive.height(1.5)));

        // 👇 subHeading2 first field ke baad
        if (subHeadings.isNotEmpty && subHeadings[0] != null) {
          fieldWidgets.add(
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 6),
              child: Text(
                subHeadings[0],
                style: TextStyle(
                  fontSize: Responsive.fontSize(4.2),
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
          if (subQuestions.isNotEmpty && subQuestions[0] != null) {
            fieldWidgets.add(
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  subQuestions[1], // Tell us how many of each property type...
                  style: TextStyle(
                    fontSize: Responsive.fontSize(3.3),
                    color: AppColors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            );
          }
        }

        continue;
      }

      // 🔹 Last field (bio) → single + usse pehle subHeading2
      if (isLast) {
        // 👇 subHeading2 bio se pehle
        if (subHeadings.length > 1 && subHeadings[1] != null) {
          fieldWidgets.add(
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 6),
              child: Text(
                subHeadings[1],
                style: TextStyle(
                  fontSize: Responsive.fontSize(4.2),
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
        }

        fieldWidgets.add(buildTextField(field));
        fieldWidgets.add(SizedBox(height: Responsive.height(2)));
        continue;
      }

      if (i >= fields.length - 3) {
        fieldWidgets.add(buildTextField(field));
        fieldWidgets.add(SizedBox(height: Responsive.height(2)));
        continue;
      }

      if (i < fields.length - 1) {
        final nextField = fields[i + 1];

        fieldWidgets.add(
          Row(
            children: [
              Expanded(child: buildTextField(field)),
              SizedBox(width: 12),
              Expanded(child: buildTextField(nextField)),
            ],
          ),
        );

        fieldWidgets.add(SizedBox(height: Responsive.height(2)));
        i++;
      } else {
        fieldWidgets.add(buildTextField(field));
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (page["subQuestion"] != null)
            Text(
              page["subQuestion"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3.3),
                color: AppColors.black,
                fontFamily: 'Poppins',
              ),
            ),

          SizedBox(height: Responsive.height(3)),

          ...fieldWidgets,

          // for (int j = 1; j < subQuestions.length; j++) ...[
          //   if (subQuestions[j] != null)
          //     Padding(
          //       padding: EdgeInsets.only(bottom: 12),
          //       child: Text(
          //         subQuestions[j],
          //         style: TextStyle(
          //           fontSize: Responsive.fontSize(3.3),
          //           color: AppColors.black,
          //           fontFamily: 'Poppins',
          //         ),
          //       ),
          //     ),
          // ],
        ],
      ),
    );
  }

  Widget buildFieldPage4(Map<String, dynamic> page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Responsive.height(1)),

          // Main Question
          if (page["question"] != null)
            Text(
              page["question"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4.2),
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          SizedBox(height: Responsive.height(1.5)),

          // SubQuestion
          if (page["subQuestion"] != null)
            Text(
              page["subQuestion"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3.3),
                color: AppColors.black,
                fontFamily: 'Poppins',
              ),
            ),

          SizedBox(height: Responsive.height(2)),

          // SubQuestion2
          if (page["subQuestion2"] != null)
            Text(
              page["subQuestion2"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3.6),
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          SizedBox(height: Responsive.height(1)),

          // Loop through fields
          ...page["fields"].asMap().entries.map<Widget>((entry) {
            final index = entry.key;
            final field = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Special condition before Field 1 → show SubQuestion3
                if (index == 1 && page["subQuestion3"] != null) ...[
                  Text(
                    page["subQuestion3"],
                    style: TextStyle(
                      fontSize: Responsive.fontSize(3.5),
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: Responsive.height(1)),
                ],

                SizedBox(height: Responsive.height(2)),

                // Special condition before Field 2 → show Question2 & SubQuestion4
                if (index == 2) ...[
                  if (page["question2"] != null)
                    Text(
                      page["question2"],
                      style: TextStyle(
                        fontSize: Responsive.fontSize(4.2),
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  SizedBox(height: Responsive.height(2)),

                  if (page["subQuestion4"] != null)
                    Text(
                      page["subQuestion4"],
                      style: TextStyle(
                        fontSize: Responsive.fontSize(3.5),
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  SizedBox(height: Responsive.height(2)),
                ],

                // The field itself
                TextField(
                  onChanged:
                      (val) => controller.fieldData[field["label"]] = val,
                  decoration: InputDecoration(
                    hintText: field["hint"],
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.grey,
                      fontSize: Responsive.fontSize(4),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Responsive.screenWidth * 0.08,
                      vertical: Responsive.screenHeight * 0.02,
                    ),
                    filled: true,
                    fillColor: AppColors.lightgrey,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.bordergrey,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Responsive.height(1.5)),
              ],
            );
          }).toList(),

          SizedBox(height: Responsive.height(2)),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightBlue, width: 1.5),
            ),
            child: Row(
              children: [
                SvgPicture.asset(AppImages.bulb),
                SizedBox(width: Responsive.width(4)),
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pro Tip",
                          style: TextStyle(
                            fontSize: Responsive.fontSize(5),
                            color: AppColors.blueMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Agents who share their performance data receive 3x more appraisal requests.",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(3),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFieldPage5(Map<String, dynamic> page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Question
          if (page["question"] != null)
            Text(
              page["question"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4.5),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
          const SizedBox(height: 10),

          // 🔹 SubQuestion
          if (page["subQuestion"] != null)
            Text(
              page["subQuestion"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3),
                color: Colors.grey,
                fontFamily: "poppins",
              ),
            ),
          SizedBox(height: Responsive.height(4)),

          // 🔹 Heading2
          if (page["heading2"] != null)
            Text(
              page["heading2"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
          SizedBox(height: Responsive.height(2)),

          // 🔹 Special case for 2 fields in row with dash
          if (page["fields"] != null && page["fields"].length == 2)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: page["fields"][0]["hint"],
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.grey,
                        fontSize: Responsive.fontSize(4),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Responsive.screenWidth * 0.08,
                        vertical: Responsive.screenHeight * 0.02,
                      ),
                      filled: true,
                      fillColor: AppColors.lightgrey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.bordergrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "-",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: page["fields"][1]["hint"],
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.grey,
                        fontSize: Responsive.fontSize(4),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Responsive.screenWidth * 0.08,
                        vertical: Responsive.screenHeight * 0.02,
                      ),
                      filled: true,
                      fillColor: AppColors.lightgrey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.bordergrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          SizedBox(height: Responsive.height(2)),
          Text(
            "Example: \$2,000 - \$4,500",
            style: TextStyle(
              fontSize: Responsive.fontSize(3),
              color: Colors.grey,
              fontFamily: "poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFieldPage6(
      Map<String, dynamic> page,
      RxBool toggle1,
      RxBool toggle2,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          if (page["question"] != null)
            Text(
              page["question"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4.5),
                fontWeight: FontWeight.bold,
                fontFamily: "poppins",
                color: AppColors.black,
              ),
            ),
          const SizedBox(height: 10),

          // SubQuestion
          if (page["subQuestion"] != null)
            Text(
              page["subQuestion"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3.2),
                color: Colors.grey,
                fontFamily: "poppins",
              ),
            ),
          SizedBox(height: Responsive.height(3)),

          // Heading2 + Field
          if (page["heading2"] != null) ...[
            Text(
              page["heading2"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: page["fields"][0]["hint"],
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.grey,
                  fontSize: Responsive.fontSize(4),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.screenWidth * 0.08,
                  vertical: Responsive.screenHeight * 0.02,
                ),
                filled: true,
                fillColor: AppColors.lightgrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(3)),
          ],

          // Heading3 + Field
          if (page["heading3"] != null) ...[
            Text(
              page["heading3"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: page["fields"][1]["hint"],
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.grey,
                  fontSize: Responsive.fontSize(4),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.screenWidth * 0.08,
                  vertical: Responsive.screenHeight * 0.02,
                ),
                filled: true,
                fillColor: AppColors.lightgrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(3)),
          ],

          // Heading4 + Field
          if (page["heading4"] != null) ...[
            Text(
              page["heading4"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: page["fields"][2]["hint"],
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.grey,
                  fontSize: Responsive.fontSize(4),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.screenWidth * 0.08,
                  vertical: Responsive.screenHeight * 0.02,
                ),
                filled: true,
                fillColor: AppColors.lightgrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(3)),
          ],

          // Switch Container 1
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lease Renewal Fee",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(4),
                          fontWeight: FontWeight.bold,
                          fontFamily: "poppins",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Charge a fee for renewing a lease?",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(3),
                          color: Colors.grey,
                          fontFamily: "poppins",
                        ),
                      ),
                    ],
                  ),
                  CustomSwitch(
                    value: controller.toggleLeaseRenewal.value,
                    onChanged:
                        (val) => controller.toggleLeaseRenewal.value = val,
                  ),
                ],
              );
            }),
          ),

          // Switch Container 2
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Negotiable?",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(4),
                          fontWeight: FontWeight.bold,
                          fontFamily: "poppins",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Are your fees negotiable?",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(3),
                          color: Colors.grey,
                          fontFamily: "poppins",
                        ),
                      ),
                    ],
                  ),
                  CustomSwitch(
                    value: controller.toggleNegotiable.value,
                    onChanged: (val) => controller.toggleNegotiable.value = val,
                  ),
                ],
              );
            }),
          ),

          SizedBox(height: Responsive.height(3)),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.lightBlue, width: 1.5),
            ),
            child: Row(
              children: [
                SvgPicture.asset(AppImages.bulb),
                SizedBox(width: Responsive.width(4)),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Agents who share their rental fees get 2x more landlord inquiries.",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(3),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFieldPage7(Map<String, dynamic> page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          if (page["question"] != null) ...[
            Text(
              page["question"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4.5),
                fontWeight: FontWeight.bold,
                fontFamily: "poppins",
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 10),
          ],

          // SubQuestion
          if (page["subQuestion"] != null) ...[
            Text(
              page["subQuestion"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3.2),
                color: Colors.grey,
                fontFamily: "poppins",
              ),
            ),
            SizedBox(height: Responsive.height(3)),
          ],

          // Heading2 + Field
          if (page["heading2"] != null) ...[
            Text(
              page["heading2"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: page["fields"][0]["hint"],
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.grey,
                  fontSize: Responsive.fontSize(4),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.screenWidth * 0.08,
                  vertical: Responsive.screenHeight * 0.02,
                ),
                filled: true,
                fillColor: AppColors.lightgrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(3)),
          ],

          // Heading3 + Field
          if (page["heading3"] != null) ...[
            Text(
              page["heading3"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: page["fields"][1]["hint"],
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.grey,
                  fontSize: Responsive.fontSize(4),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.screenWidth * 0.08,
                  vertical: Responsive.screenHeight * 0.02,
                ),
                filled: true,
                fillColor: AppColors.lightgrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(3)),
          ],

          // Heading4 + Field
          if (page["heading4"] != null) ...[
            Text(
              page["heading4"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: page["fields"][2]["hint"],
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.grey,
                  fontSize: Responsive.fontSize(4),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.screenWidth * 0.08,
                  vertical: Responsive.screenHeight * 0.02,
                ),
                filled: true,
                fillColor: AppColors.lightgrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(15)),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightgrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightgrey, width: 1.5),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(AppImages.bulb),
                  SizedBox(width: Responsive.width(4)),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Agents who share their rental fees get 2x more landlord inquiries.",
                          style: TextStyle(
                            fontSize: Responsive.fontSize(3),
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildFieldPage8(Map<String, dynamic> page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          // Question
          if (page["question"] != null)
            Text(
              page["question"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4.5),
                fontWeight: FontWeight.bold,
                fontFamily: "poppins",
                color: AppColors.black,
              ),
            ),
          const SizedBox(height: 10),

          // SubQuestion
          if (page["subQuestion"] != null)
            Text(
              page["subQuestion"],
              style: TextStyle(
                fontSize: Responsive.fontSize(3.2),
                color: Colors.grey,
                fontFamily: "poppins",
              ),
            ),
          SizedBox(height: Responsive.height(3)),

          // Heading2 + Field
          if (page["heading2"] != null) ...[
            Text(
              page["heading2"],
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: page["fields"][0]["hint"],
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.grey,
                  fontSize: Responsive.fontSize(4),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.screenWidth * 0.08,
                  vertical: Responsive.screenHeight * 0.02,
                ),
                filled: true,
                fillColor: AppColors.lightgrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.bordergrey, width: 2),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(3)),

            // 🔹 Use current location button
            ElevatedButton.icon(
              onPressed: () {
                // controller.setLocation("User Current Location (from GPS)");
              },
              icon: Icon(Icons.my_location, color: AppColors.black),
              label: Text(
                "Use Current Location",
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: "poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.map2,
                  fit: BoxFit.cover,
                  width: Responsive.width(85),
                  height: double.infinity,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget buildFieldPage2(Map<String, dynamic> page) {

  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Question
  //         Text(
  //           page["question"],
  //           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 8),

  //         // SubQuestion (if exists)
  //         if (page["subQuestion"] != null)
  //           Text(
  //             page["subQuestion"],
  //             style: const TextStyle(fontSize: 14, color: Colors.grey),
  //           ),

  //         const SizedBox(height: 20),

  //         // Fields
  //         ...page["fields"].map<Widget>((field) {
  //           if (field["type"] == "dropdown") {
  //             final options = List<String>.from(field["options"]);
  //             return Padding(
  //               padding: const EdgeInsets.only(bottom: 16),
  //               child: Obx(() {
  //                 final selected =
  //                     controller.fieldData[field["label"]] ?? options.first;
  //                 return DropdownButtonFormField2<String>(
  //                   isExpanded: true,
  //                   value: selected,
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontFamily: "Poppins",
  //                     color: Colors.black, // Selected value color
  //                   ),
  //                   items:
  //                       options
  //                           .map(
  //                             (opt) => DropdownMenuItem(
  //                               value: opt,
  //                               child: Text(
  //                                 opt,
  //                                 style: const TextStyle(
  //                                   fontSize: 16,
  //                                   fontFamily: "Poppins",
  //                                   color: AppColors.grey,
  //                                 ),
  //                               ),
  //                             ),
  //                           )
  //                           .toList(),
  //                   onChanged: (val) {
  //                     controller.fieldData[field["label"]] = val ?? "";
  //                   },

  //                   // 🔹 Yahan aapka custom InputDecoration apply ho raha hai
  //                   decoration: InputDecoration(
  //                     hintText: field["hint"],
  //                     hintStyle: TextStyle(
  //                       fontFamily: 'Poppins',
  //                       color: AppColors.grey,
  //                       fontSize: Responsive.fontSize(4),
  //                     ),
  //                     contentPadding: EdgeInsets.symmetric(
  //                       horizontal: Responsive.screenWidth * 0.08,
  //                       vertical: Responsive.screenHeight * 0.02,
  //                     ),
  //                     filled: true,
  //                     fillColor: AppColors.lightgrey,

  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(30),
  //                       borderSide: BorderSide(color: Colors.grey.shade300),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(30),
  //                       borderSide: BorderSide(
  //                         color: AppColors.bordergrey,
  //                         width: 2,
  //                       ),
  //                     ),
  //                     errorBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(30),
  //                       borderSide: const BorderSide(color: Colors.red),
  //                     ),
  //                     focusedErrorBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(30),
  //                       borderSide: const BorderSide(
  //                         color: Colors.red,
  //                         width: 2,
  //                       ),
  //                     ),
  //                   ),

  //                   buttonStyleData: ButtonStyleData(
  //                     height: Responsive.height(3), // same height as your field
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: Responsive.width(2),
  //                     ),
  //                   ),

  //                   // 🔹 Dropdown ki styling (popup menu)
  //                   dropdownStyleData: DropdownStyleData(
  //                     maxHeight: 300,

  //                     padding: const EdgeInsets.symmetric(vertical: 8),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12),
  //                       color: AppColors.lightgrey,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black26,
  //                           blurRadius: 6,
  //                           offset: const Offset(0, 3),
  //                         ),
  //                       ],
  //                     ),
  //                   ),

  //                   // 🔹 Items style
  //                   menuItemStyleData: const MenuItemStyleData(
  //                     height: 48,
  //                     padding: EdgeInsets.symmetric(horizontal: 16),
  //                   ),
  //                 );
  //               }),
  //             );
  //           } else {

  //             return Padding(
  //               padding: const EdgeInsets.only(bottom: 16),
  //               child: TextField(
  //                 onChanged:
  //                     (val) => controller.fieldData[field["label"]] = val,
  //                 decoration: InputDecoration(
  //                   hintText: field["hint"],
  //                   hintStyle: TextStyle(
  //                     fontFamily: 'Poppins',
  //                     color: AppColors.grey,
  //                     fontSize: Responsive.fontSize(4),
  //                   ),
  //                   contentPadding: EdgeInsets.symmetric(
  //                     horizontal: Responsive.screenWidth * 0.08,
  //                     vertical: Responsive.screenHeight * 0.02,
  //                   ),

  //                   filled: true,
  //                   fillColor: AppColors.lightgrey,

  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(30),
  //                     borderSide: BorderSide(color: Colors.grey.shade300),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(30),
  //                     borderSide: BorderSide(
  //                       color: AppColors.bordergrey,
  //                       width: 2,
  //                     ),
  //                   ),
  //                   errorBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(30),
  //                     borderSide: BorderSide(color: Colors.red),
  //                   ),
  //                   focusedErrorBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(30),
  //                     borderSide: BorderSide(color: Colors.red, width: 2),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }
  //         }).toList(),
  //       ],
  //     ),
  //   );
  // }

  // -------------------
  // Final Page
  Widget buildFinalPage(Map<String, dynamic> page) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Check Circle
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: AppColors.blueMain,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              "Profile Submitted Successfully!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              "You’re almost live, we are verifying your details\n(24–48 hrs).",
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Stepper
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.blueMain,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Info Submitted",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(4.5),
                        fontFamily: "poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 9),
                  height: 20,
                  width: 2,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.blueMain, width: 3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.blueMain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Under Review",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(4.5),
                        fontFamily: "poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 9),
                  height: 20,
                  width: 2,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Profile Goes Live",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(4.5),
                        fontFamily: "poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // const SizedBox(height: 40),

            // Button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //     ),
            //     onPressed: () {},
            //     child: const Text(
            //       "Preview Profile",
            //       style: TextStyle(fontSize: 16, color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: 50,
        height: 30, // circle jitni height
        child: Stack(
          children: [
            // background line
            Center(
              child: Container(
                width: 33,
                height: 14, // slim line
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: value ? AppColors.lightBlue : AppColors.lightgrey,
                  border: Border.all(
                    color: value ? AppColors.blueMain : AppColors.grey,
                    width: 2,
                  ),
                ),
              ),
            ),
            // circle
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? AppColors.blueMain : Colors.grey,
                ),
                child: Icon(
                  value ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}