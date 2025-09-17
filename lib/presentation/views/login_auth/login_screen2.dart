import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/auth_vm.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class LoginView2 extends StatelessWidget {
  LoginView2({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final authController = Get.find<AuthController>();
  // final GoogleAuthController controller = Get.find<GoogleAuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: Responsive.height(10)),

                SvgPicture.asset(
                  AppImages.logo2,
                  height: Responsive.height(12),
                ),
                SizedBox(height: Responsive.height(10)),
                Obx(
                  () => SizedBox(
                    width: Responsive.width(80),
                    height: Responsive.height(7),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBlue,
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(30),
                            ),
                            border: Border.all(
                              color: AppColors.blueMain,
                              width: 2,
                            ),
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                authController.isLoading.value
                                    ? null
                                    : () async {
                                      if (_formKey.currentState!.validate()) {
                                        authController.isLoading.value = true;

                                        await Future.delayed(
                                          const Duration(seconds: 2),
                                        );

                                        bool success = await authController
                                            .login(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );

                                        // await AppNotificationService.saveDeviceToken();

                                        authController.isLoading.value = false;

                                        if (success) {
                                          Get.offAllNamed(AppRoutes.home);
                                        } else {
                                          Get.snackbar("Error", "Login failed");
                                        }
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(30),
                                ),
                              ),
                            ),
                            child:
                                authController.isLoading.value
                                    ? const SizedBox.shrink()
                                    : Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.google,
                                          height: Responsive.height(4),
                                        ),
                                        SizedBox(width: Responsive.width(7)),
                                        const Text(
                                          "Continue with Gmail",
                                          style: TextStyle(
                                            color: AppColors.blueMain,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),

                        // Loader
                        if (authController.isLoading.value)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Responsive.height(2)),
                Obx(
                  () => SizedBox(
                    width: Responsive.width(80),
                    height: Responsive.height(7),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBlue,
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(30),
                            ),
                            border: Border.all(
                              color: AppColors.blueMain,
                              width: 2,
                            ),
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                authController.isLoading.value
                                    ? null
                                    : () async {
                                      if (_formKey.currentState!.validate()) {
                                        authController.isLoading.value = true;

                                        await Future.delayed(
                                          const Duration(seconds: 2),
                                        );

                                        bool success = await authController
                                            .login(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );

                                        // await AppNotificationService.saveDeviceToken();

                                        authController.isLoading.value = false;

                                        if (success) {
                                          Get.offAllNamed(AppRoutes.home);
                                        } else {
                                          Get.snackbar("Error", "Login failed");
                                        }
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(30),
                                ),
                              ),
                            ),
                            child:
                                authController.isLoading.value
                                    ? const SizedBox.shrink()
                                    : Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.facebook,
                                          height: Responsive.height(4),
                                        ),
                                        SizedBox(width: Responsive.width(7)),
                                        const Text(
                                          "Continue with Facebook",
                                          style: TextStyle(
                                            color: AppColors.blueMain,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),

                        // Loader
                        if (authController.isLoading.value)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Responsive.height(2)),
                Obx(
                  () => SizedBox(
                    width: Responsive.width(80),
                    height: Responsive.height(7),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBlue,
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(30),
                            ),
                            border: Border.all(
                              color: AppColors.blueMain,
                              width: 2,
                            ),
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                authController.isLoading.value
                                    ? null
                                    : () async {
                                      if (_formKey.currentState!.validate()) {
                                        authController.isLoading.value = true;

                                        await Future.delayed(
                                          const Duration(seconds: 2),
                                        );

                                        bool success = await authController
                                            .login(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );

                                        // await AppNotificationService.saveDeviceToken();

                                        authController.isLoading.value = false;

                                        if (success) {
                                          Get.offAllNamed(AppRoutes.home);
                                        } else {
                                          Get.snackbar("Error", "Login failed");
                                        }
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(30),
                                ),
                              ),
                            ),
                            child:
                                authController.isLoading.value
                                    ? const SizedBox.shrink()
                                    : Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.phone,
                                          height: Responsive.height(4),
                                        ),
                                        SizedBox(width: Responsive.width(7)),
                                        const Text(
                                          "Continue with Phone",
                                          style: TextStyle(
                                            color: AppColors.blueMain,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),

                        // Loader
                        if (authController.isLoading.value)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Responsive.height(10)),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: Responsive.width(8)),
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(2),
                      ),
                      child: Text(
                        "or",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: Responsive.fontSize(3.5),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: Responsive.width(8)),
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Responsive.height(8)),

                Obx(
                  () => SizedBox(
                    width: Responsive.width(80),
                    height: Responsive.height(7),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.blueMain,
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(30),
                            ),
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.login);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(30),
                                ),
                              ),
                            ),
                            child:
                                authController.isLoading.value
                                    ? const SizedBox.shrink() // Text hide loader ke waqt
                                    : const Text(
                                      "Continue with Email",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                          ),
                        ),

                        // Loader
                        if (authController.isLoading.value)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Responsive.height(2)),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account ? ",
                    style: TextStyle(
                      fontSize: Responsive.fontSize(3.5),
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Signup",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(3.5),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: AppColors.blueMain,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(AppRoutes.signUp);
                              },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Responsive.height(5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
