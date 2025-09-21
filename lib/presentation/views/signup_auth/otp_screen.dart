// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:propmeet/domain/viewmodels/auth_vm.dart';

// class VerifyOtpScreen extends StatelessWidget {
//   final String phoneNumber;
//   VerifyOtpScreen({super.key, required this.phoneNumber});

//   final AuthController controller = Get.put(AuthController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Verify OTP"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Enter OTP sent to $phoneNumber",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             // OTP Boxes
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(6, (index) {
//                 return SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: TextField(
//                     controller: controller.otpControllers[index],
//                     textAlign: TextAlign.center,
//                     keyboardType: TextInputType.number,
//                     maxLength: 1,
//                     decoration: InputDecoration(
//                       counterText: "",
//                       filled: true,
//                       fillColor: Colors.grey[300], // AppColors.lightgrey
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10), // circular 10
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     onChanged: (value) {
//                       if (value.isNotEmpty && index < 5) {
//                         FocusScope.of(context).nextFocus();
//                       }
//                       if (value.isEmpty && index > 0) {
//                         FocusScope.of(context).previousFocus();
//                       }
//                     },
//                   ),
//                 );
//               }),
//             ),

//             const SizedBox(height: 30),

//             ElevatedButton(
//               onPressed: () {
//                 String otp = controller.otpCode;
//                 if (otp.length == 6) {
//                   Get.snackbar("OTP Entered", otp);
//                   // Yahan firebase verify call karna
//                 } else {
//                   Get.snackbar("Error", "Please enter complete OTP");
//                 }
//               },
//               child: const Text("Verify"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/auth_vm.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String phoneNumber;
  VerifyOtpScreen({super.key, required this.phoneNumber});

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Responsive.padding(6)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Responsive.height(10)),
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: Responsive.fontSize(8),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: AppColors.blueMain,
                ),
              ),
              SizedBox(height: Responsive.height(3.2)),
        
              SvgPicture.asset(AppImages.logo2, height: Responsive.height(12)),
        
              SizedBox(height: Responsive.height(5)),
              Text(
                "Code has been sent to $phoneNumber",
                style: TextStyle(
                  fontSize: Responsive.fontSize(4),
                  fontFamily: "poppins",
                ),
              ),
              SizedBox(height: Responsive.height(3)),
        
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter Code Here ",
                  style: TextStyle(
                    fontSize: Responsive.fontSize(4),
                    fontFamily: "poppins",
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: Responsive.height(3)),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // AppColors.lightGrey
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: controller.otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
        
              SizedBox(height: Responsive.height(2)),
        
              RichText(
                text: TextSpan(
                  text: "Did not receive code? ",
                  style: TextStyle(
                    fontSize: Responsive.fontSize(3),
                    fontFamily: 'Poppins',
                    color: Colors.black, // ya theme ke hisaab se
                  ),
                  children: [
                    TextSpan(
                      text: "Resend",
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
        
              SizedBox(height: Responsive.height(25)),
        
              // // Verify Button
              // Obx(
              //   () => SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.7,
              //     height: 50,
              //     child: ElevatedButton(
              //       onPressed:
              //           controller.isLoading.value
              //               ? null
              //               : () {
              //                 String otp = controller.otpCode;
              //                 if (otp.length == 6) {
              //                   controller.verifyOtp(otp);
              //                 } else {
              //                   Get.snackbar(
              //                     "Error",
              //                     "Please enter complete OTP",
              //                   );
              //                 }
              //               },
              //       style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //       ),
              //       child:
              //           controller.isLoading.value
              //               ? const CircularProgressIndicator(color: Colors.white)
              //               : const Text(
              //                 "Verify OTP",
              //                 style: TextStyle(fontSize: 16),
              //               ),
              //     ),
              //   ),
              // ),
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
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () {
                                    String otp = controller.otpCode;
                                    if (otp.length == 6) {
                                      controller.verifyOtp(otp);
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        "Please enter complete OTP",
                                      );
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
                              controller.isLoading.value
                                  ? const SizedBox.shrink() // Text hide loader ke waqt
                                  : const Text(
                                    "Confirm",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                        ),
                      ),
        
                      // Loader
                      if (controller.isLoading.value)
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
            ],
          ),
        ),
      ),
    );
  }
}
