import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2E8B57);
  static const background = Colors.white;
  static const textPrimary = Colors.black;
  static const textSecondary = Colors.black54;
  static const cardBackground = Color(0xFFF5F5F5); // A light grey for cards
  static const accent = Color(0xFF8BC34A); // A light green for accent
  static const secondaryAccent = Color(0xFF64B5F6); // A light blue for secondary accent
  // Add more colors as needed
}

class AppTextStyles {
  static const appName = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const button = TextStyle(fontSize: 18, color: Colors.white);

  static const link = TextStyle(color: AppColors.primary, fontSize: 16);

  static const body = TextStyle(color: AppColors.textSecondary, fontSize: 16);

  // Add more text styles as needed
}
