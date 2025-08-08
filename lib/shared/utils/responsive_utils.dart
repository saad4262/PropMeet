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

  static double height(double percent) => blockHeight * percent;

  static double width(double percent) => blockWidth * percent;

  static double fontSize(double percent) => blockWidth * percent;

  static double radius(double percent) => blockWidth * percent;

  static double padding(double percent) => blockWidth * percent;

  static double margin(double percent) => blockWidth * percent;
}
