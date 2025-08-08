import 'package:flutter/material.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class AppTextTheme {
  static  TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: Responsive.fontSize(34), fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: Responsive.fontSize(24), fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: Responsive.fontSize(18), fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: Responsive.fontSize(14)),
  );
}
