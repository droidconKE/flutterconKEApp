import 'package:flutter/material.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

/// Colors for a panel whose scheme *inverts* between light and dark mode —
/// a deliberate design choice from the 2026 rebrand, not a dark-mode bug.
/// Two documented instances on the web (see docs/design/REBRAND-PLAN.md):
/// the About stat panel (black background + magenta figures in light mode,
/// magenta background + white figures in dark mode) and the Developer Days
/// card (same pattern). Register one instance per `ThemeData.extensions` so
/// screens read `Theme.of(context).extension<InvertedPanelColors>()!`
/// instead of hardcoding the swap themselves.
@immutable
class InvertedPanelColors extends ThemeExtension<InvertedPanelColors> {
  const InvertedPanelColors({required this.background, required this.figure});

  /// Light mode: black background, magenta figures.
  static const InvertedPanelColors light = InvertedPanelColors(
    background: ThemeColors.blackColor,
    figure: ThemeColors.flutterconMagenta,
  );

  /// Dark mode: magenta background, white figures.
  static const InvertedPanelColors dark = InvertedPanelColors(
    background: ThemeColors.flutterconMagenta,
    figure: Colors.white,
  );

  final Color background;
  final Color figure;

  @override
  InvertedPanelColors copyWith({Color? background, Color? figure}) {
    return InvertedPanelColors(
      background: background ?? this.background,
      figure: figure ?? this.figure,
    );
  }

  @override
  InvertedPanelColors lerp(
    ThemeExtension<InvertedPanelColors>? other,
    double t,
  ) {
    if (other is! InvertedPanelColors) return this;
    return InvertedPanelColors(
      background: Color.lerp(background, other.background, t) ?? background,
      figure: Color.lerp(figure, other.figure, t) ?? figure,
    );
  }
}
