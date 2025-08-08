import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:propmeet/domain/viewmodels/splash_vm.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueMain,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Responsive.height(10)),

            SvgPicture.asset(AppImages.logo, height: Responsive.height(60)),
            SizedBox(height: Responsive.height(5)),
            Lottie.asset(AppImages.loading, height: Responsive.height(13)),
          ],
        ),
      ),
    );
  }
}
