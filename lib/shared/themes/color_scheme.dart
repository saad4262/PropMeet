import 'package:flutter/material.dart';

class AppColorScheme {
  static const lightColorScheme = ColorScheme.light(
    primary: Color(0xFF1565C0),
    secondary: Color(0xFF42A5F5),
    background: Color(0xFFF5F5F5),
    onPrimary: Colors.white,
  );

  static const darkColorScheme = ColorScheme.dark(
    primary: Color(0xFF90CAF9),
    secondary: Color(0xFF64B5F6),
    background: Color(0xFF121212),
    onPrimary: Colors.black,
  );
}
