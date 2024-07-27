import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDurations {
  static const Duration fastest = Duration(seconds: 1);

  static const Duration fast = Duration(seconds: 2);

  static const Duration medium = Duration(seconds: 3);

  static const Duration slow = Duration(seconds: 5);
}

class Sizes {
  /// extra small size = 5
  static const double xs = 5;

  /// small size = 10
  static const double sm = 10;

  /// medium size = 15
  static const double m = 15;

  /// large size = 20
  static const double l = 20;

  /// extra large size = 30
  static const double xl = 30;

  /// extra extra large size = 50
  static const double xxl = 50;
}

class ThemeFonts {
  static const String poppins = 'Poppins';
}

class Insets {
  static double gutterScale = 1;

  static const double scale = 1;

  /// Dynamic insets, may get scaled with the device size
  static double mGutter = m * gutterScale;

  static double lGutter = l * gutterScale;

  static const double xs = 2 * scale;
  static const double sm = 6 * scale;
  static const double m = 12 * scale;
  static const double l = 24 * scale;
  static const double xl = 36 * scale;
}

class Shadows {
  static bool enabled = true;

  static double get mRadius => 8;

  static List<BoxShadow> m(Color color, [double opacity = 0]) {
    return enabled
        ? [
            BoxShadow(
              color: color.withOpacity(opacity),
              blurRadius: mRadius,
              spreadRadius: mRadius / 2,
              offset: const Offset(1, 0),
            ),
            BoxShadow(
              color: color.withOpacity(opacity),
              blurRadius: mRadius / 2,
              spreadRadius: mRadius / 4,
              offset: const Offset(1, 0),
            ),
          ]
        : const <BoxShadow>[];
  }
}

class Corners {
  static const double btn = s5;

  static const double dialog = 12;

  /// Xs
  static const double s3 = 3;

  static BorderRadius get s3Border => BorderRadius.all(s3Radius);

  static Radius get s3Radius => const Radius.circular(s3);

  /// Small
  static const double s5 = 5;

  static BorderRadius get s5Border => BorderRadius.all(s5Radius);

  static Radius get s5Radius => const Radius.circular(s5);

  /// Medium
  static const double s8 = 8;

  static const BorderRadius s8Border = BorderRadius.all(s8Radius);

  static const Radius s8Radius = Radius.circular(s8);

  /// Large
  static const double s10 = 10;

  static BorderRadius get s10Border => BorderRadius.all(s10Radius);

  static Radius get s10Radius => const Radius.circular(s10);
}
