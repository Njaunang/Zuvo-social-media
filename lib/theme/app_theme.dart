import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zuvo/constant/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: cyberRose,
    scaffoldBackgroundColor: trueWhite,
    fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
    appBarTheme: AppBarThemeData(
      backgroundColor: trueWhite,
      elevation: 0,
      centerTitle: false,
      foregroundColor: deepNight,
      iconTheme: IconThemeData(color: deepNight),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: trueWhite,
      prefixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 30),
      suffixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 30),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: cyberRose),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: deepNight.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: cyberRose, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: TextStyle(color: deepNight),
      hintStyle: TextStyle(
        color: deepNight.withValues(alpha: 0.5),
        fontSize: 16,
      ),
      prefixStyle: TextStyle(color: deepNight),
      suffixStyle: TextStyle(color: deepNight, fontSize: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: cyberRose,
        foregroundColor: deepNight,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        minimumSize: Size(double.infinity, 30),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: cyberRose),
        ),
        foregroundColor: cyberRose,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        minimumSize: Size(double.infinity, 30),
      ),
    ),
    textTheme: TextTheme(
      // Display styles - Large headings
      displayLarge: TextStyle(
        fontSize: 62,
        fontWeight: FontWeight.bold,
        color: deepNight,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: deepNight,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: deepNight,
      ),
      // Headline styles - Section titles
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: deepNight,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: deepNight,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: deepNight,
      ),
      // Title styles
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: deepNight,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: deepNight,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: deepNight,
      ),
      // Body styles - Regular text
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: deepNight,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: deepNight,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: deepNight,
      ),
      // Label styles
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: deepNight,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: deepNight,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: deepNight,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: cyberRose,
    scaffoldBackgroundColor: deepNight,
    fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
    appBarTheme: AppBarThemeData(
      backgroundColor: deepNight,
      foregroundColor: trueWhite,
      iconTheme: IconThemeData(color: softOffWhite),
      centerTitle: false,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: deepNight,
      prefixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 30),
      suffixIconConstraints: BoxConstraints(minWidth: 30, minHeight: 30),
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: trueWhite.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: trueWhite.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: cyberRose, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      hintStyle: TextStyle(
        color: trueWhite.withValues(alpha: 0.5),
        fontSize: 14,
      ),
      labelStyle: TextStyle(color: trueWhite),
      prefixStyle: TextStyle(color: trueWhite),
      suffixStyle: TextStyle(color: trueWhite, fontSize: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: cyberRose,
        foregroundColor: deepNight,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        minimumSize: Size(double.infinity, 30),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: cyberRose),
        ),
        foregroundColor: trueWhite,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        minimumSize: Size(double.infinity, 30),
        iconColor: cyberRose,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: deepNight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      shadowColor: cyberRose,
    ),
    textTheme: TextTheme(
      // Display styles - Large headings
      displayLarge: TextStyle(
        fontSize: 62,
        fontWeight: FontWeight.bold,
        color: trueWhite,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: trueWhite,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: trueWhite,
      ),
      // Headline styles - Section titles
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: trueWhite,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: trueWhite,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: trueWhite,
      ),
      // Title styles
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: trueWhite,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: trueWhite,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: trueWhite,
      ),
      // Body styles - Regular text
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: trueWhite,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: trueWhite,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: trueWhite,
      ),
      // Label styles
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: trueWhite,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: trueWhite,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: trueWhite,
      ),
    ),
  );
}
