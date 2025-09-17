import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SnackbarHelper {
  static bool _isSnackbarActive = false;

  static void showOnce({
    required String title,
    required String message,
    Color backgroundColor = Colors.black,
  }) {
    if (_isSnackbarActive) return;

    _isSnackbarActive = true;

    Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
    );

    Timer(const Duration(seconds: 3), () {
      _isSnackbarActive = false;
    });
  }
}

