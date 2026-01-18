import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GhostTheme {
  // Brand Colors
  static const Color ectoGreen = Color(0xFF00FF41);
  static const Color glitchRed = Color(0xFFFF003C);
  static const Color hologramBlue = Color(0xFF00F0FF); // The missing color

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.vt323(
          color: ectoGreen,
          fontSize: 64,
          letterSpacing: 4,
        ),
        bodyLarge: GoogleFonts.shareTechMono(
          color: ectoGreen,
          fontSize: 18,
        ),
        bodyMedium: GoogleFonts.shareTechMono(
          color: ectoGreen.withOpacity(0.7),
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: ectoGreen,
          side: const BorderSide(color: ectoGreen, width: 2),
          textStyle: GoogleFonts.vt323(fontSize: 24),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}