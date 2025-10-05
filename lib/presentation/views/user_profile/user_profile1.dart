import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/setupprofile_vm.dart';
import 'package:propmeet/presentation/views/map_screen.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class ProfileSetupScreen extends StatelessWidget {
  final ProfileSetup controller = Get.put(ProfileSetup());
  final PageController pageController = PageController();

  ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: Responsive.height(5)),

          Padding(
            padding: EdgeInsets.all(Responsive.padding(5)),
            child: Obx(
              () => LinearProgressIndicator(
                value: controller.progressPercent.value,
                backgroundColor: AppColors.grey.shade400,
                color: AppColors.blueMain,
                minHeight: 6,
              ),
            ),
          ),
          SizedBox(height: Responsive.height(3)),
          Obx(() {
            return controller.currentPage.value == 0
                ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.padding(5),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hi Jhon,",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(5),
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueMain,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                )
                : const SizedBox.shrink();
          }),

          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: controller.totalPages,
              onPageChanged: (index) => controller.updatePage(index),
              itemBuilder: (context, index) {
                final pageData = controller.pagesData[index];

                if (index == controller.totalPages - 1) {
                  return buildPropertyDetailsPage(pageData);
                }

                if (index == 2) {
                  final pageData = controller.pagesData[index];
                  return buildLocationPage(
                    pageData["question"] as String,
                    pageData["subQuestion"] as String?,
                  );
                }

                // if (index == 3) {
                //   final pageData = controller.pagesData[index];

                //   return showSelectedLocation(
                //     pageData["question"] as String,
                //     pageData["subQuestion"] as String?,
                //   );
                // }

                return _buildPage(
                  index,
                  pageData["question"] as String,
                  List<String>.from(pageData["options"] as List<dynamic>),
                  tags:
                      pageData["tags"] != null
                          ? List<String>.from(pageData["tags"] as List<dynamic>)
                          : null,
                  subQuestion: pageData["subQuestion"] as String?,
                  subOptions:
                      pageData["subOptions"] != null
                          ? List<String>.from(
                            pageData["subOptions"] as List<dynamic>,
                          )
                          : null,
                  images:
                      pageData["images"] != null
                          ? List<String>.from(
                            pageData["images"] as List<dynamic>,
                          )
                          : null,
                );
              },
            ),
          ),

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
                                if (controller.currentPage.value > 0) {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
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
                        onPressed: () async {
                          if (controller.currentPage.value <
                              controller.totalPages - 1) {
                            // Next page pe le jao
                            await pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // ✅ Last page = Finish button
                            await controller.saveProfileToFirestore(
                              controller.selectedPlaceDetails.value?.lat,
                              controller.selectedPlaceDetails.value?.lng,
                              controller.selectedPlaceDetails.value?.address,
                            );

                            Get.snackbar(
                              "Success",
                              "Profile setup successful 🎉",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withOpacity(0.2),
                              colorText: Colors.black,
                            );

                            // ✅ Navigate to Home Page (replace with your Home widget)
                            Get.offAllNamed(AppRoutes.home);
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

  Widget buildPropertyDetailsPage(Map<String, dynamic> pageData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pageData["question"],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            pageData["subQuestion"],
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),

          // ✅ Dynamic Fields
          ...List.generate((pageData["fields"] as List).length, (fieldIndex) {
            final field = pageData["fields"][fieldIndex];
            final title = field["title"] as String;
            final options = List<String>.from(field["options"]);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        options.map((option) {
                          final isSelected =
                              (controller.propertyDetails[title] ?? "") ==
                              option;

                          return ChoiceChip(
                            label: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 10,
                              ), // ✅ bigger size

                              child: Text(option),
                            ),
                            selected: isSelected,
                            showCheckmark: false, // ✅ Tick remove
                            backgroundColor: Colors.grey.shade200,
                            selectedColor: AppColors.secondaryBlue,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? AppColors.lightBlue
                                        : Colors.grey.shade400,
                                width: 1.5,
                              ),
                            ),
                            onSelected:
                                (_) => controller.setPropertyDetail(
                                  title,
                                  option,
                                  controller.selectedPlaceDetails.value?.lat,
                                  controller.selectedPlaceDetails.value?.lng,
                                  controller
                                      .selectedPlaceDetails
                                      .value
                                      ?.address,
                                ),
                          );
                        }).toList(),
                  );
                }),
                const SizedBox(height: 16),
              ],
            );
          }),
          SizedBox(height: Responsive.height(5)),

          // ✅ Pro Tip Note
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
                        pageData["note"] ?? "",
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

  Widget _buildPage(
    int pageIndex,
    String question,
    List<String> options, {
    String? subQuestion,
    List<String>? subOptions,
    List<String>? images,
    List<String>? tags,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Responsive.padding(2.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.padding(2.5)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    question,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(5),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Responsive.height(2)),
          Padding(
            padding: EdgeInsets.only(
              left: Responsive.padding(2.5),
              right: Responsive.padding(9),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    subQuestion ?? "",
                    style: TextStyle(
                      fontSize: Responsive.fontSize(3.3),
                      color: AppColors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Text(
          //   question,
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 10),

          // // Sub Question (optional)
          // if (subQuestion != null)
          //   Text(
          //     subQuestion,
          //     style: const TextStyle(fontSize: 14, color: Colors.grey),
          //   ),
          const SizedBox(height: 30),

          // Options
          Obx(() {
            return Column(
              children: List.generate(options.length, (i) {
                bool isSelected = controller.selections[pageIndex] == i;

                return GestureDetector(
                  onTap:
                      () => controller.setSelection(
                        pageIndex,
                        i,
                        controller.selectedPlaceDetails.value?.lat,
                        controller.selectedPlaceDetails.value?.lng,
                        controller.selectedPlaceDetails.value?.address,
                      ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (tags != null && i < tags.length)
                              Text(
                                tags[i] ?? "",
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(4.5),
                                  color: AppColors.grey.shade700,
                                ),
                              )
                            else
                              const SizedBox.shrink(), // empty jagah agar tags null ho
                            // Spacer ensures right-side circle always stick to end
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
                                            color:
                                                isSelected
                                                    ? AppColors.lightBlue
                                                    : AppColors.grey,
                                          ),
                                        ),
                                      )
                                      : null,
                            ),
                          ],
                        ),

                        SizedBox(height: Responsive.height(3)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // Circular Radio Button
                            // const SizedBox(width: 12),

                            // Image (if available)
                            if (images != null && i < images.length)
                              SvgPicture.asset(
                                images[i],
                                height: Responsive.height(4),
                                width: Responsive.width(4),
                              ),

                            if (images != null) const SizedBox(width: 10),
                            SizedBox(width: Responsive.width(5)),
                            // Text + SubOption
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    options[i],
                                    style: TextStyle(
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

  Widget buildLocationPage(String question, String? subQuestion) {
    final TextEditingController searchController = TextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.padding(2.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Question
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.padding(2.5)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    question,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(5),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Responsive.height(2)),
          Padding(
            padding: EdgeInsets.only(
              left: Responsive.padding(2.5),
              right: Responsive.padding(9),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    subQuestion ?? "",
                    style: TextStyle(
                      fontSize: Responsive.fontSize(3.3),
                      color: AppColors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: Responsive.height(2)),

          Padding(
            padding: EdgeInsets.only(left: Responsive.padding(2)),
            child: Container(
              height: Responsive.height(13),
              width: Responsive.width(90),
              decoration: BoxDecoration(
                color: AppColors.secondaryBlue,
                border: Border.all(color: AppColors.lightBlue),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: Responsive.width(2)),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(AppImages.shield),
                  ),
                  SizedBox(width: Responsive.width(3)),
                  // ✅ Wrap Column in Expanded
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Address is protected",
                          style: TextStyle(
                            color: AppColors.blueMain,
                            fontFamily: "poppins",
                            fontSize: Responsive.fontSize(4),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Your address stays private until you choose to share it with agent",
                          style: TextStyle(
                            color: AppColors.grey,
                            fontFamily: "poppins",
                            fontSize: Responsive.fontSize(3.2),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Responsive.height(2)),

          // 🔹 Search Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onTap: () async {
                final result = await Get.to(() => MapScreen()); // open map
                if (result != null) {
                  // Update location in controller
                  if (result != null) {
                    // result already PlaceDetails hoga
                    controller.selectedPlaceDetails.value = result;
                  }
                }
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.black,
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => Text(
                      controller.selectedPlaceDetails.value?.address ??
                          "Enter your location",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        fontFamily: "poppins",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Use current location button
          ElevatedButton.icon(
            onPressed: () {
              controller.getUserCurrentLocation();
              if (controller.selectedPlaceDetails.value != null) {
                final place = controller.selectedPlaceDetails.value!;
                print("📍 Address: ${place.address}");
                print("Lat: ${place.lat}, Lng: ${place.lng}");
              }
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

          Expanded(
            child: Container(
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
          ),
        ],
      ),
    );
  }

  Widget showSelectedLocation(String question, String? subQuestion) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Responsive.padding(2.5)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(2.5),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      question,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(5),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Responsive.height(2)),
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.padding(2.5),
                right: Responsive.padding(9),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      subQuestion ?? "",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(3.3),
                        color: AppColors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: Responsive.height(2)),

            Padding(
              padding: EdgeInsets.only(left: Responsive.padding(2)),
              child: Container(
                height: Responsive.height(13),
                width: Responsive.width(90),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBlue,
                  border: Border.all(color: AppColors.lightBlue),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: Responsive.width(2)),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AppImages.shield),
                    ),
                    SizedBox(width: Responsive.width(3)),
                    // ✅ Wrap Column in Expanded
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Address is protected",
                            style: TextStyle(
                              color: AppColors.blueMain,
                              fontFamily: "poppins",
                              fontSize: Responsive.fontSize(4),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Your address stays private until you choose to share it with agent",
                            style: TextStyle(
                              color: AppColors.grey,
                              fontFamily: "poppins",
                              fontSize: Responsive.fontSize(3.2),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Responsive.height(2)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.black,
                  ),
                  const SizedBox(width: 10),
                  Obx(() {
                    if (controller.selectedPlaceDetails.value?.address ==
                        null) {
                      return const Text(
                        "No location selected",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    return Text(
                      "Selected: ${controller.selectedPlaceDetails.value?.address}\n",
                      // "Lat: ${controller.selectedLat.value}, Lng: ${controller.selectedLng.value}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
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
            ),

            const SizedBox(height: 30),
            Obx(() {
              if (controller.selectedPlaceDetails.value?.address == null) {
                return const Text(
                  "No location selected",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              }

              return Text(
                "Selected: ${controller.selectedPlaceDetails.value?.address}\n",
                // "Lat: ${controller.selectedLat.value}, Lng: ${controller.selectedLng.value}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
