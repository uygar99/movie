import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color black = Color(0xFF0F0E0E);
  static const Color white = Color(0xFFF3E9E9);
  static const Color gray = Color(0xFFDED5D5);
  static const Color grayDark = Color(0xFF968D8D);
  static const Color redDark = Color(0xFF8C2626);
  static const Color redLight = Color(0xFFCB2C2C);
  static const Color successGreen = Color(0xFF00FF85);
  static const Color darkGray = Color(0xFF2A2A2A);
  
  static const Color selectionInsetRed = Color(0x4DCB2C2C);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: redLight,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.dark(
        primary: redLight,
        secondary: grayDark,
        surface: black,
        error: redDark,
        onPrimary: white,
        onSurface: white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          color: white,
          fontSize: 72,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
        displayMedium: GoogleFonts.inter(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
        headlineLarge: GoogleFonts.inter(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
        bodyLarge: GoogleFonts.inter(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
        labelLarge: GoogleFonts.inter(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.0,
        ),
        titleLarge: GoogleFonts.inter(
          color: black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
        bodyMedium: GoogleFonts.inter(
          color: gray,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: redLight,
          disabledBackgroundColor: redDark,
          foregroundColor: white,
          disabledForegroundColor: white.withOpacity(0.5),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
          minimumSize: const Size(335, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(4),
        ),
      ),
    );
  }
}
