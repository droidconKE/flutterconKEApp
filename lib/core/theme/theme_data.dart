import 'package:flutter/material.dart';

import 'package:fluttercon/core/theme/theme_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: ThemeColors.blueDroidconColor,
        primaryContainer: ThemeColors.blueDroidconColor,
        onPrimary: Colors.white,
        secondary: ThemeColors.blueGreenDroidconColor,
        secondaryContainer: ThemeColors.blueGreenDroidconColor,
        onSecondary: Colors.black,
        surface: Colors.grey,
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
        brightness: Brightness.light,
        primary: ThemeColors.blueDroidconColor,
        primaryContainer: ThemeColors.blueDroidconColor,
        onPrimary: Colors.black,
        secondary: ThemeColors.blueGreenDroidconColor,
        secondaryContainer: ThemeColors.blueGreenDroidconColor,
        onSecondary: Colors.white,
        surface: Colors.grey,
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
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
