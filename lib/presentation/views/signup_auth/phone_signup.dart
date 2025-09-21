import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/auth_vm.dart';
import 'package:propmeet/presentation/views/signup_auth/otp_screen.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class PhoneSignup extends StatelessWidget {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Responsive.height(8)),

              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: Responsive.fontSize(8),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: AppColors.blueMain,
                ),
              ),
              SizedBox(height: Responsive.height(4)),

              SvgPicture.asset(AppImages.logo2, height: Responsive.height(14)),

              SizedBox(height: Responsive.height(5)),
              Text(
                "Continue with Phone Number ",
                style: TextStyle(
                  fontSize: Responsive.fontSize(4.5),
                  fontFamily: "poppins",
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Responsive.height(5)),

              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: Responsive.radius(
                        14,
                      ), // same as CircleAvatar diameter
                      width: Responsive.radius(14),
                      decoration: BoxDecoration(
                        color: AppColors.lightgrey,
                        borderRadius: BorderRadius.circular(
                          18,
                        ), // 👈 circular border radius
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImages.phone,
                          height: Responsive.height(3.5),
                          width: Responsive.width(3.5),
                        ),
                      ),
                    ),
                    Obx(() {
                      return Column(
                        children: [
                          if (!authController.isOtpSent.value) ...[
                            SizedBox(
                              width: Responsive.width(60),
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
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
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
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
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Responsive.height(2)),
                            const SizedBox(height: 10),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     String number = phoneController.text.trim();
                            //     if (number.isEmpty) {
                            //       Get.snackbar(
                            //         "Error",
                            //         "Please enter your phone number",
                            //       );
                            //     } else {
                            //       authController.sendOtp(number);
                            //     }
                            //   },
                            //   child:
                            //       authController.isLoading.value
                            //           ? const CircularProgressIndicator(
                            //             color: Colors.white,
                            //           )
                            //           : const Text("Send OTP"),
                            // ),

                            // ] else ...[
                            //   TextField(
                            //     controller: otpController,
                            //     decoration: const InputDecoration(
                            //       labelText: "Enter OTP",
                            //     ),
                            //   ),
                            //   SizedBox(height: Responsive.height(2)),

                            //   ElevatedButton(
                            //     onPressed: () {
                            //       authController.verifyOtp(otpController.text);
                            //     },
                            //     child:
                            //         authController.isLoading.value
                            //             ? const CircularProgressIndicator(
                            //               color: Colors.white,
                            //             )
                            //             : const Text("Verify OTP"),
                            //   ),
                          ],
                        ],
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: Responsive.height(8)),
              Obx(
                () => SizedBox(
                  width: Responsive.width(80),
                  height: Responsive.height(7),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Button background aur style same
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
                          // onPressed: () {
                          //   String number = phoneController.text.trim();
                          //   if (number.isEmpty) {
                          //     Get.snackbar(
                          //       "Error",
                          //       "Please enter your phone number",
                          //     );
                          //   } else {
                          //     authController.sendOtp(number);
                          //   }
                          // },
                          onPressed: () {
                            String number = phoneController.text.trim();
                            if (number.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please enter your phone number",
                              );
                            } else {
                              authController.sendOtp(number);
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
                                  ? const SizedBox.shrink() // Text hide loader ke waqt
                                  : const Text(
                                    "Send OTP",
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

              SizedBox(height: Responsive.height(3)),

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
                      "or continue with",
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

              SizedBox(height: Responsive.height(3)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(5),
                        ),
                      ),
                      side: BorderSide(color: Color(0xffD4D4D4), width: 2),

                      elevation: 5,
                      padding: EdgeInsets.all(Responsive.padding(5)),
                      shadowColor: AppColors.black,
                    ),

                    child: SvgPicture.asset(
                      AppImages.google,
                      height: Responsive.height(3.5),
                      width: Responsive.width(3.5),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Facebook sign-in logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(5),
                        ),
                      ),
                      side: BorderSide(color: Color(0xffD4D4D4), width: 2),
                      elevation: 5,
                      padding: EdgeInsets.all(Responsive.padding(5)),
                      shadowColor: AppColors.black,
                    ),

                    child: SvgPicture.asset(
                      AppImages.facebook,
                      height: Responsive.height(3.5),
                      width: Responsive.width(3.5),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.phoneSignup);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Responsive.radius(5),
                        ),
                      ),
                      side: BorderSide(color: Color(0xffD4D4D4), width: 2),
                      elevation: 5,
                      padding: EdgeInsets.all(Responsive.padding(5)),
                      shadowColor: AppColors.black,
                    ),

                    child: SvgPicture.asset(
                      AppImages.phone,
                      height: Responsive.height(3.5),
                      width: Responsive.width(3.5),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.height(2)),

              RichText(
                text: TextSpan(
                  text: "Already have an account ? ",
                  style: TextStyle(
                    fontSize: Responsive.fontSize(3),
                    fontFamily: 'Poppins',
                    color: Colors.black, // ya theme ke hisaab se
                  ),
                  children: [
                    TextSpan(
                      text: "Login",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(3),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: AppColors.blueMain, // alag color
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              // Login page navigate karne ka code yahan
                              Get.toNamed(AppRoutes.login2);
                            },
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.height(1)),

              Text(
                "I am an Agent",
                style: TextStyle(
                  fontSize: Responsive.fontSize(3),
                  fontFamily: 'Poppins',
                  color: AppColors.blueMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
