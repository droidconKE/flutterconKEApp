import 'package:flutter/material.dart';

enum Flavor { dev, prod }

class FlavorValues {
  final bool logNetworkInfo;
  final bool showFullErrorMessages;

  const FlavorValues({
    required this.logNetworkInfo,
    required this.showFullErrorMessages,
  });
}

class FlavorConfig {
  double devicePixelRatio = 1;
  final Flavor flavor;
  final String name;
  final Color color;
  final FlavorValues values;
  ThemeMode themeMode;
  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required Color color,
    required FlavorValues values,
    ThemeMode themeMode = ThemeMode.system,
  }) =>
      _instance =
          FlavorConfig._internal(flavor, name, color, values, themeMode);

  FlavorConfig._internal(
      this.flavor, this.name, this.color, this.values, this.themeMode);

  static FlavorConfig get instance => _instance!;

  static bool get hasInstance => _instance != null;

  static bool isProd() => _instance!.flavor == Flavor.prod;

  static bool isDev() => _instance!.flavor == Flavor.dev;
}
