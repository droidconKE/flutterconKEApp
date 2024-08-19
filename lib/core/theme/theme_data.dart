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
        primary: ThemeColors.blueDroidconColor,
        primaryContainer: ThemeColors.blueDroidconColor,
        onPrimary: Colors.white,
        secondary: ThemeColors.blueGreenDroidconColor,
        secondaryContainer: ThemeColors.lightGrayColor,
        onSecondary: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ThemeColors.blueDroidconColor,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: ThemeColors.blueDroidconColor,
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
      scaffoldBackgroundColor: ThemeColors.greyDarkThemeBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: ThemeColors.blueGreenDroidconColor,
        primaryContainer: ThemeColors.blueDroidconColor,
        onPrimary: Colors.black,
        secondary: ThemeColors.blueDroidconColor,
        secondaryContainer: Colors.black,
        onSecondary: Colors.white,
        surface: ThemeColors.blackColor,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.greyDarkThemeBackground,
        foregroundColor: ThemeColors.blueDroidconColor,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.black,
        indicatorColor: ThemeColors.blueDroidconColor,
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
