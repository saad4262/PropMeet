import 'package:flutter/material.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class AppFonts {
  static const String primaryFont = 'Poppins';

  static double small(BuildContext context) => Responsive.fontSize(12);

  static double normal(BuildContext context) => Responsive.fontSize(14);

  static double large(BuildContext context) => Responsive.fontSize(18);

  static double title(BuildContext context) => Responsive.fontSize(24);
}
