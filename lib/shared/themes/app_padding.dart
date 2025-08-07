import 'package:flutter/material.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class AppPadding {
  static double small(BuildContext context) => Responsive.padding(8.0);
  static double normal(BuildContext context) => Responsive.padding(16.0);
  static double large(BuildContext context) => Responsive.padding(24.0);
  static double xLarge(BuildContext context) => Responsive.padding(32.0);
}
