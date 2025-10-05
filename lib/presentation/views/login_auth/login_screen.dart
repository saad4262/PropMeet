import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/auth_vm.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

import '../../../shared/config/app_assets/app_assets.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

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
                SizedBox(height: Responsive.height(5)),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: Responsive.fontSize(7),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: AppColors.blueMain,
                  ),
                ),
                SizedBox(height: Responsive.height(4)),

                SvgPicture.asset(
                    AppAssets.homeIcon,
                  color: AppColors.blueMain,
                  height: Responsive.height(10),
                ),
                SizedBox(height: Responsive.height(5)),
                SizedBox(
                  width: Responsive.width(80),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: AppColors.grey),
                      hintText: "Email",
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
                    validator:
                        (v) =>
                            !GetUtils.isEmail(v!) ? "Enter valid email" : null,
                  ),
                ),
                SizedBox(height: Responsive.height(2)),
                Obx(
                  () => SizedBox(
                    width: Responsive.width(80),
                    child: TextFormField(
                      controller: _passwordController,

                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: AppColors.grey),
                        hintText: "Password",
                        filled: true,
                        fillColor: AppColors.lightgrey,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Responsive.screenWidth * 0.08,
                          vertical: Responsive.screenHeight * 0.02,
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.grey,
                          fontSize: Responsive.fontSize(4),
                        ),
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

                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.grey,
                          ),
                          onPressed: () {
                            authController.togglePasswordVisibility();
                          },
                        ),
                      ),
                      obscureText: authController.isPasswordHidden.value,
                      validator:
                          (v) =>
                              v!.length < 6
                                  ? "Password must be at least 6 chars"
                                  : null,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.height(2)),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      // Get.toNamed(AppRoutes.forgetPassword);
                    },
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontFamily: "poppins",
                        color: AppColors.blueMain,
                        fontSize: Responsive.fontSize(3.5),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Responsive.height(2)),

                Padding(
                  padding: EdgeInsets.only(left: Responsive.width(10)),
                  child: GestureDetector(
                    onTap: authController.toggleRemember,
                    child: Obx(
                      () => Row(
                        children: [
                          Container(
                            width: Responsive.width(5),
                            height: Responsive.height(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 2,
                                color:
                                    authController.isRemember.value
                                        ? AppColors.blueMain
                                        : AppColors.blueMain,
                              ),
                              color:
                                  authController.isRemember.value
                                      ? AppColors.blueMain
                                      : Colors.transparent,
                            ),
                            child:
                                authController.isRemember.value
                                    ? Icon(
                                      Icons.check,
                                      size: Responsive.radius(3),
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                          SizedBox(width: Responsive.width(2)),
                          Text(
                            'Remember me',
                            style: TextStyle(fontSize: Responsive.fontSize(4)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Responsive.height(3)),
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

                                        // if (success) {
                                        //   Get.offAllNamed(AppRoutes.bottomBarView);
                                        // } else {
                                        //   Get.snackbar("Error", "Login failed");
                                        // }
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
                                      "Login",
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

                SizedBox(height: Responsive.height(2.5)),
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
                        // Apple sign-in logic here
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
