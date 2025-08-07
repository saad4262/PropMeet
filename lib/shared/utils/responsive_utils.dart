import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static late double blockWidth;   // 1% of screen width
  static late double blockHeight;  // 1% of screen height

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

  static double heightPercent(double percent) => blockHeight * percent;

  static double widthPercent(double percent) => blockWidth * percent;

  static double fontSize(double percent) => blockWidth * percent;

  static double radius(double percent) => blockWidth * percent;

  static double padding(double percent) => blockWidth * percent;

  static double margin(double percent) => blockWidth * percent;
}
