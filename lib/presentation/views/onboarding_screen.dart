import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/onboarding_vm.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final controller = Get.find<OnboardingController>();
  final PageController pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      "image": AppImages.onboarding1,
      "title": "Discover Agents Near You",
      "desc":
          "Connect with verified property agents within your area — fast, easy, and personalized",
    },
    {
      "image": AppImages.onboarding2,
      "title": "Swipe. Match. Connect",
      "desc":
          "Swipe through agent profiles to find the perfect match for your property needs.",
    },
    {
      "image": AppImages.onboarding3,
      "title": "Instant Messaging, Real Connections",
      "desc":
          "Start real-time conversations with matched agents to discuss listings, offers, and more.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  controller.pageIndex.value = index;
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        onboardingData[index]['image']!,
                        height: Responsive.height(30),
                      ),
                      SizedBox(height: Responsive.height(5)),
                      Text(
                        onboardingData[index]['title']!,
                        style: TextStyle(
                          fontSize: Responsive.fontSize(7),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Responsive.height(2)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.padding(10),
                        ),
                        child: Text(
                          onboardingData[index]['desc']!,
                          style: TextStyle(
                            fontSize: Responsive.fontSize(4),
                            color: AppColors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Responsive.padding(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Responsive.width(60),
                    height: Responsive.height(7),
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.pageIndex.value < 2) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          controller.skip();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueMain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(30),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.padding(15),
                          vertical: Responsive.padding(2),
                        ),
                      ),
                      child: Text(
                        controller.pageIndex.value == 2 ? "Finish" : "Next",
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.height(2)),

                  Container(
                    width: Responsive.width(60),
                    height: Responsive.height(7),
                    child: ElevatedButton(
                      onPressed: controller.skip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryBlue,
                        side: BorderSide(
                          color: AppColors.blueMain,
                          width: Responsive.width(0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(30),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.padding(15),
                          vertical: Responsive.padding(2),
                        ),
                      ),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: AppColors.blueMain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
