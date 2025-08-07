import 'package:flutter/material.dart';
import 'package:propmeet/shared/themes/color_scheme.dart';
import 'package:propmeet/shared/themes/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColorScheme.lightColorScheme,
    textTheme: AppTextTheme.textTheme,
    scaffoldBackgroundColor: AppColorScheme.lightColorScheme.background,
    appBarTheme: const AppBarTheme(elevation: 0),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: AppColorScheme.darkColorScheme,
    textTheme: AppTextTheme.textTheme,
    scaffoldBackgroundColor: AppColorScheme.darkColorScheme.background,
    appBarTheme: const AppBarTheme(elevation: 0),
    useMaterial3: true,
  );
}
