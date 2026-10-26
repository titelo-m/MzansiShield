import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0F1115); // Deep dark background
  static const Color surface = Color(0xFF1A1D24);    // Lighter dark for cards
  static const Color primaryOrange = Color(0xFFFF9800); // The main accent
  static const Color primaryOrangeLight = Color(0xFFFFB74D);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color alertRed = Color(0xFFE53935);
  static const Color alertRedBg = Color(0xFF3E1C1C);
  static const Color teal = Color(0xFF00BFA5);
  static const Color green = Color(0xFF4CAF50);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryOrange,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryOrange,
        surface: AppColors.surface,
        background: AppColors.background,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}