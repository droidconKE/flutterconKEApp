import 'package:flutter/material.dart';

class ThemeColors {
  ThemeColors._();

  static const Color lightGrayBackgroundColor = Color(0xffF5F5F5);
  static const Color greyDarkThemeBackground = Color(0xff000000);
  static const Color greyTextColor = Color(0xff707070);
  static const Color lightGreyTextColor = Color(0xffC3C3C3);

  static const Color blackColor = Color(0xff000000);
  static const Color lightGrayColor = Color(0xffF5F5F5);
  static const Color greyAccentColor = Color(0xffB1B1B1);

  static const Color flutterconBlue = Color(0xff008BFF);
  static const Color flutterconMagenta = Color(0xffF73EDE);
}

/// Full blue/magenta color ramps from the flutterconKE 2026 rebrand's Figma
/// variable export. Values must stay identical to `blue`/`magenta` in
/// `tailwind.config.js` on the flutterconKE2024Web repo's `dev` branch — see
/// docs/design/REBRAND-PLAN.md. [ThemeColors.flutterconBlue] is [blue700];
/// [ThemeColors.flutterconMagenta] is [magenta500] — kept as separate named
/// constants above since they're the two values used as `primary`/`accent`
/// throughout the existing theme.
class AppColorRamps {
  AppColorRamps._();

  static const Color blue50 = Color(0xffEDFAFF);
  static const Color blue100 = Color(0xffD6F3FF);
  static const Color blue200 = Color(0xffB5EBFF);
  static const Color blue300 = Color(0xff83E1FF);
  static const Color blue400 = Color(0xff48CEFF);
  static const Color blue500 = Color(0xff1EB3FF);
  static const Color blue600 = Color(0xff069AFF);
  static const Color blue700 = Color(0xff008BFF);
  static const Color blue800 = Color(0xff086AC5);
  static const Color blue900 = Color(0xff0D5A9B);

  static const Color magenta50 = Color(0xffFFF3FE);
  static const Color magenta100 = Color(0xffFFE7FE);
  static const Color magenta200 = Color(0xffFFCEFC);
  static const Color magenta300 = Color(0xffFFA7F5);
  static const Color magenta400 = Color(0xffFF57E9);
  static const Color magenta500 = Color(0xffF73EDE);
  static const Color magenta600 = Color(0xffDB1EBE);
  static const Color magenta700 = Color(0xffB6159A);
  static const Color magenta800 = Color(0xff95137D);
  static const Color magenta900 = Color(0xff791664);
}
