import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2E8B57);
  static const background = Colors.white;
  static const text = Colors.black;
  static const textSecondary = Colors.black54;
  static const accent = Colors.teal;
  // Add more colors as needed
}

class AppTextStyles {
  static const appName = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const button = TextStyle(fontSize: 18, color: Colors.white);

  static const link = TextStyle(color: AppColors.primary, fontSize: 16);

  static const body = TextStyle(color: AppColors.textSecondary, fontSize: 16);

  // Add more text styles as needed
}
