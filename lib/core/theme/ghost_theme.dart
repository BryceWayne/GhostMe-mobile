import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GhostTheme {
  // --- NEW SEANCE THEME COLORS ---
  static const Color voidPurple = Color(0xFF1A1433);
  static const Color seanceLavender = Color(0xFF9D65FF); // "Séance" (No accent)
  static const Color linkGreen = Color(0xFF00FF9D);
  static const Color deepSurface = Color(0xFF241D41);

  // --- LEGACY COLORS (Restored for LoginScreen) ---
  static const Color glitchRed = Color(0xFFFF003C); 
  static const Color ectoGreen = Color(0xFF00FF41); 
  static const Color hologramBlue = Color(0xFF00F0FF);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: voidPurple,
      primaryColor: seanceLavender,
      
      textTheme: TextTheme(
        displayLarge: GoogleFonts.creepster( 
          color: seanceLavender,
          fontSize: 48,
          letterSpacing: 2,
        ),
        bodyLarge: GoogleFonts.courierPrime(
          color: linkGreen,
          fontSize: 18,
        ),
        bodySmall: GoogleFonts.shareTechMono(
          color: seanceLavender.withOpacity(0.5),
          fontSize: 10,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: linkGreen,
          side: const BorderSide(color: linkGreen, width: 1.5),
          textStyle: GoogleFonts.shareTechMono(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        hintStyle: TextStyle(color: seanceLavender.withOpacity(0.3)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: seanceLavender, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: seanceLavender.withOpacity(0.4)),
        ),
      ),
    );
  }
}