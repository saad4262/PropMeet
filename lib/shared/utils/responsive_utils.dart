import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

  static double height(double value) => screenHeight * (value / 812);

  static double width(double value) => screenWidth * (value / 375);

  static double fontSize(double value) => screenWidth * (value / 375);

  static double radius(double value) => screenWidth * (value / 375);

  static double padding(double value) => screenWidth * (value / 375);

  static double margin(double value) => screenWidth * (value / 375);
}
