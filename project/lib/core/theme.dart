import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF5F5F5);
  static const Color dark = Colors.black87;
  static const Color light = Colors.white;
  static const Color infoCard = Color(0xFFCDE5FF);
  static const Color success = Color(0xFFE8F5E9);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(fontSize: 16, color: Colors.black87);

  static const TextStyle caption = TextStyle(fontSize: 12, color: Colors.grey);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.light,
    foregroundColor: AppColors.primary,
    surfaceTintColor: AppColors.light,
  ),
  textTheme: const TextTheme(
    bodyLarge: AppTextStyles.body,
    titleLarge: AppTextStyles.heading,
    bodySmall: AppTextStyles.caption,
  ),

  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.background,
  ),
);
