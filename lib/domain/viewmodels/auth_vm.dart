import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/data/repositories/auth_repo.dart';
import 'package:propmeet/model/authmodel/auth_model.dart';
import 'package:propmeet/presentation/views/signup_auth/otp_screen.dart';
import 'package:propmeet/presentation/widgets/snack_bar.dart';
import 'package:propmeet/shared/constants/app_colors.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  var isLoading = false.obs;
  var currentUser = Rxn<Auth>();
  var avatarFile = Rxn<File>();
  var isPasswordHidden = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isRemember = false.obs;

  var verificationId = "".obs;
  var isOtpSent = false.obs;

  Future<void> sendOtp(String phoneNumber) async {
    phoneNumber = phoneNumber.trim();

    // Pakistan number formatting
    if (phoneNumber.startsWith("0")) {
      phoneNumber = phoneNumber.replaceFirst("0", "");
      phoneNumber = "+92$phoneNumber";
    }

    if (!phoneNumber.startsWith("+")) {
      phoneNumber = "+92$phoneNumber";
    }

    try {
      isLoading.value = true;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        // Agar OTP auto verify ho jaye
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            Get.snackbar("Success", "Phone verified automatically!");
            // 👇 Auto verify ke baad directly home/dashboard bhej do
            Get.offAllNamed("/home");
          } catch (e) {
            Get.snackbar("Error", e.toString());
          }
        },

        // Agar OTP send karte waqt error aaye
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          Get.snackbar("Error", e.message ?? "Verification failed");
        },

        // OTP code send ho gaya
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          isLoading.value = false;

          // 👇 Ab OTP screen pe le jao
          Get.to(() => VerifyOtpScreen(phoneNumber: phoneNumber));
        },

        // Agar OTP timeout ho gaya
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      isLoading.value = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      Get.snackbar("Success", "Phone number verified!");
    } catch (e) {
      Get.snackbar("Error", "Invalid OTP");
    } finally {
      isLoading.value = false;
    }
  }

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  // OTP ka combined value
  String get otpCode => otpControllers.map((e) => e.text).join();

  void clearOtp() {
    for (var c in otpControllers) {
      c.clear();
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRemember() {
    isRemember.value = !isRemember.value;
    // If using persistence, write to storage:
    // _box.write(_key, isRemember.value);
  }

  void setRemember(bool value) {
    isRemember.value = value;
    // _box.write(_key, isRemember.value);
  }
  // AuthController({AuthRepository? repository})
  //   : _repo = repository ?? AuthRepository(CloudinaryService(Dio()));

  Future<bool> signUp(String email, String password, String name) async {
    isLoading.value = true;
    try {
      final user = await _repo.signUp(
        email,
        password,
        // name,
        // avatarFile: avatarFile.value,
      );
      currentUser.value = user;

      SnackbarHelper.showOnce(
        title: "Success",
        message: "Account created successfully",
        backgroundColor: AppColors.successColor,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        SnackbarHelper.showOnce(
          title: "Error",
          message: "This email is already registered",
          backgroundColor: AppColors.errorColor,
        );
      } else if (e.code == 'weak-password') {
        SnackbarHelper.showOnce(
          title: "Error",
          message: "Password is too weak",
          backgroundColor: AppColors.errorColor,
        );
      } else if (e.code == 'invalid-email') {
        SnackbarHelper.showOnce(
          title: "Error",
          message: "Invalid email format",
          backgroundColor: AppColors.errorColor,
        );
      } else {
        // Get.snackbar(
        //   "Error",
        //   e.message ?? "An error occurred",
        //   backgroundColor: AppColors.errorColor,
        // );
        SnackbarHelper.showOnce(
          title: "Error",
          message: "An error occurred",
          backgroundColor: AppColors.errorColor,
        );
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _repo.login(email, password);
      currentUser.value = user;
      Get.closeCurrentSnackbar();

      Get.snackbar(
        "Success",
        "Login successful",
        backgroundColor: AppColors.successColor,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.closeCurrentSnackbar();

        Get.snackbar(
          "Error",
          "No user found with this email",
          backgroundColor: AppColors.errorColor,
        );
      } else if (e.code == 'wrong-password') {
        Get.closeCurrentSnackbar();

        Get.snackbar(
          "Error",
          "Incorrect password",
          backgroundColor: AppColors.errorColor,
        );
      } else {
        Get.closeCurrentSnackbar();

        Get.snackbar(
          "Error",
          e.message ?? "An error occurred",
          backgroundColor: AppColors.errorColor,
        );
      }
      return false;
    } catch (e) {
      Get.closeCurrentSnackbar();

      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: AppColors.errorColor,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void setAvatar(File? file) {
    avatarFile.value = file;
  }

  Future<void> logout() async {
    await _repo.logout();
    Get.snackbar(
      "Logged Out",
      "You have successfully logged out.",
      backgroundColor: AppColors.successColor,
    );

    Get.offAllNamed(AppRoutes.login);
  }

  void resetPassword(String email) async {
    isLoading.value = true;
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      if (snapshot.docs.isEmpty) {
        Get.snackbar(
          "Error",
          "No user found with this email",
          backgroundColor: AppColors.errorColor,
        );
      } else {
        await _auth.sendPasswordResetEmail(email: email);
        Get.snackbar(
          "Success",
          "Password reset email sent",
          backgroundColor: AppColors.successColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: AppColors.errorColor,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
