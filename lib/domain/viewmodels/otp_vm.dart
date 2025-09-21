import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OtpController extends GetxController {
  // 6 digit OTP ke liye controllers
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  // OTP ka combined value
  String get otpCode => otpControllers.map((e) => e.text).join();

  void clearOtp() {
    for (var c in otpControllers) {
      c.clear();
    }
  }

  
}
