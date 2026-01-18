import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GhostTheme {
  // The Palette
  static const Color voidBlack = Color(0xFF050505); // Deeper than pure black
  static const Color ectoGreen = Color(0xFF00FF41); // Matrix/Terminal Green
  static const Color phantomPurple = Color(0xFFBC13FE); // Cyberpunk accent
  static const Color glitchRed = Color(0xFFFF003C); // Error/Destruct

  // The Theme Data
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: voidBlack,
      brightness: Brightness.dark,
      
      // Typography (The "Voice")
      textTheme: TextTheme(
        displayLarge: GoogleFonts.vt323(
          color: ectoGreen,
          fontSize: 42,
          fontWeight: FontWeight.bold,
          shadows: [
            const Shadow(color: ectoGreen, blurRadius: 10),
          ],
        ),
        bodyLarge: GoogleFonts.shareTechMono(
          color: ectoGreen.withOpacity(0.9),
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.shareTechMono(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
        ),
      ),

      // Input Decoration (The "Console")
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: voidBlack,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ectoGreen.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ectoGreen, width: 2),
          borderRadius: BorderRadius.zero, // Sharp corners for tech feel
        ),
        hintStyle: TextStyle(color: ectoGreen.withOpacity(0.4)),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: ectoGreen,
          side: const BorderSide(color: ectoGreen),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Rectangular buttons
          ),
          textStyle: GoogleFonts.vt323(fontSize: 24),
        ),
      ),
    );
  }
}