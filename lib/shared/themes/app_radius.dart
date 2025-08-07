import 'package:flutter/material.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class AppRadius {
  static double small(BuildContext context) => Responsive.radius(6.0);
  static double normal(BuildContext context) => Responsive.radius(12.0);
  static double large(BuildContext context) => Responsive.radius(20.0);
}
