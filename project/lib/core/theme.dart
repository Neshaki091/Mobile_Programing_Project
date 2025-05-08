import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF5F5F5);
  static const Color dark = Colors.black87;
  static const Color light = Colors.white;
  static const Color infoCard = Color(0xFFCDE5FF);
  static const Color success = Color(0xFFE8F5E9);

  // Dark theme colors
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color secondaryDark = Color(0xFF2196F3);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color darkModeText = Colors.white;
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color infoCardDark = Color(0xFF0D47A1);
  static const Color successDark = Color(0xFF1B5E20);
}

class AppTextStyles {
  // Light theme text styles
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(fontSize: 16, color: Colors.black87);

  static const TextStyle caption = TextStyle(fontSize: 12, color: Colors.grey);

  // Dark theme text styles
  static const TextStyle headingDark = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyDark = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  static const TextStyle captionDark = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
}

// Giữ nguyên appTheme làm lightTheme
final ThemeData lightTheme = ThemeData(
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

// Tạo mới dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryDark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.darkCardColor,
    foregroundColor: AppColors.light,
    surfaceTintColor: AppColors.darkCardColor,
  ),
  textTheme: const TextTheme(
    bodyLarge: AppTextStyles.bodyDark,
    titleLarge: AppTextStyles.headingDark,
    bodySmall: AppTextStyles.captionDark,
  ),

  cardColor: AppColors.darkCardColor,
  dialogBackgroundColor: AppColors.darkCardColor,

  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryDark,
    secondary: AppColors.secondaryDark,
    background: AppColors.backgroundDark,
    surface: AppColors.darkCardColor,
  ),

  // Tùy chỉnh màu sắc cho các thành phần cụ thể trong dark mode
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkCardColor,
    selectedItemColor: AppColors.primaryDark,
    unselectedItemColor: Colors.grey,
  ),

  // Màu nền cho các widget như Dialog, BottomSheet
  canvasColor: AppColors.backgroundDark,

  // Màu cho divider (đường phân cách)
  dividerColor: Colors.grey[800],

  // Màu cho RadioButton, Checkbox
  // toggleableActiveColor: AppColors.primaryDark,
);
