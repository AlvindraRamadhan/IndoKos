import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF00B8A9);
  static const secondary = Color(0xFFF8F9FA);
  static const accent = Color(0xFF17C3B2);
  static const textDark = Color(0xFF212529);
  static const textLight = Color(0xFF6C757D);
}

class AppTextStyles {
  static const headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  static const headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
  static const bodyText1 = TextStyle(fontSize: 16, color: AppColors.textDark);
  static const bodyText2 = TextStyle(fontSize: 14, color: AppColors.textLight);
}
