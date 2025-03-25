import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // App Colors
  static const Color primaryColor = Color(0xFF00336A); // Dark blue
  static const Color secondaryColor = Colors.white;
  static const Color accentColor = Color(0xFFBEFF00); // Lime green
  static const Color textColor = Color(0xFF505050); // Gray
  static const Color inactiveColor = Color(0xFF808075); // Gray
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  
  // Text Styles
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 22, 
        fontWeight: FontWeight.bold, 
        color: textColor,
      );
  
  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 18, 
        fontWeight: FontWeight.w600, 
        color: textColor,
      );
  
  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 16, 
        fontWeight: FontWeight.w600, 
        color: textColor,
      );
  
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16, 
        fontWeight: FontWeight.normal, 
        color: textColor,
      );
  
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14, 
        fontWeight: FontWeight.normal, 
        color: textColor,
      );
  
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12, 
        fontWeight: FontWeight.normal, 
        color: textColor,
      );
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: secondaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: secondaryColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: inactiveColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        elevation: 4,
      ),
      cardTheme: CardTheme(
        color: secondaryColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEEEE),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.inter(color: textColor),
        hintStyle: GoogleFonts.inter(color: inactiveColor),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: titleMedium,
        contentTextStyle: bodyMedium,
      ),
    );
  }
}
