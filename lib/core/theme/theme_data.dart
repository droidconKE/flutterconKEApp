import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // On the colorScheme, add the color for light theme
  // And the corresponding color for dark theme on the same property
  // Example:
  //
  // Light theme
  // surface: Colors.white,
  // onSurface: Colors.black,
  //
  // Dark theme
  // surface: ThemeColors.blackColor,
  // onSurface: Colors.white,

  static ThemeData lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: ThemeColors.flutterconBlue,
        primaryContainer: ThemeColors.flutterconBlue,
        onPrimary: Colors.white,
        secondary: ThemeColors.flutterconMagenta,
        secondaryContainer: ThemeColors.lightGrayColor,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xff20201E),
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ThemeColors.flutterconBlue,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: ThemeColors.flutterconBlue,
        elevation: 3,
      ),
      textTheme: GoogleFonts.montserratTextTheme(),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      scaffoldBackgroundColor: ThemeColors.blackColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: ThemeColors.flutterconBlue,
        primaryContainer: ThemeColors.flutterconBlue,
        onPrimary: Colors.white,
        secondary: ThemeColors.flutterconMagenta,
        secondaryContainer: Color(0xff191D1D),
        onSecondary: Colors.white,
        surface: Color(0xff20201E),
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.blackColor,
        foregroundColor: ThemeColors.flutterconBlue,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: ThemeColors.blackColor,
        indicatorColor: ThemeColors.flutterconBlue,
        elevation: 3,
      ),
      textTheme: GoogleFonts.montserratTextTheme(),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
