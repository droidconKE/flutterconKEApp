import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class ThemeFonts {
  static const themeFonts = 'TrebuchetMS';

  static const title = themeFonts;
  static const body = themeFonts;
  static const button = themeFonts;
}

class FontSizes {
  /// font size 10
  static const double s10 = 10;

  /// font size 12
  static const double s12 = 12;

  /// font size 14
  static const double s14 = 14;

  /// font size 16
  static const double s16 = 16;

  /// font size 18
  static const double s18 = 18;

  /// font size 20
  static const double s20 = 20;

  /// font size 22
  static const double s22 = 22;

  /// font size 25
  static const double s25 = 25;

  /// font size 30
  static const double s30 = 30;
}

class TextStyles {
  static const TextStyle trebuchetMS = TextStyle(
    fontFamily: ThemeFonts.themeFonts,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1,
    fontFamilyFallback: [
      ThemeFonts.themeFonts,
    ],
  );

  static TextStyle get pageTitle1 =>
      trebuchetMS.bold.size(FontSizes.s30).letterSpace(2);

  static TextStyle get headingStyle1 =>
      trebuchetMS.bold.size(FontSizes.s22).letterSpace(.5);

  static TextStyle get headingStyle2 =>
      trebuchetMS.bold.size(FontSizes.s20).letterSpace(.3);

  static TextStyle get headingStyle3 => trebuchetMS.bold.size(FontSizes.s18);

  static TextStyle get headingStyle4 => trebuchetMS.bold.size(FontSizes.s16);

  static TextStyle get headingStyle5 => trebuchetMS.bold.size(FontSizes.s14);

  static TextStyle get headingStyle6 => trebuchetMS.bold.size(FontSizes.s12);

  static TextStyle get bodyStyle1 => trebuchetMS.size(FontSizes.s16);

  static TextStyle get bodyStyle2 => trebuchetMS.size(FontSizes.s14);

  static TextStyle get bodyStyle3 => trebuchetMS.size(FontSizes.s12);

  static TextStyle get callOut =>
      trebuchetMS.size(FontSizes.s20).letterSpace(1.5).bold;

  static TextStyle get callOutFocus => callOut.bold;

  static TextStyle get buttonTextStyle =>
      trebuchetMS.bold.size(FontSizes.s14).letterSpace(1.75);

  static TextStyle get buttonSelected =>
      trebuchetMS.size(FontSizes.s14).letterSpace(1.75);

  static TextStyle get footNote => trebuchetMS.bold.size(FontSizes.s10);

  static TextStyle get captionText =>
      trebuchetMS.size(FontSizes.s10).letterSpace(.3);

  static TextStyle get titleStyle12 =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
  static TextStyle get titleStyle14 =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  static TextStyle get titleStyle22 =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 22);
  static TextStyle get titleStyle20 =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  static TextStyle get labelStyle16 =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
}
