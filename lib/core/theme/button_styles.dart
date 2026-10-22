import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';

/// Pill-shaped button styles introduced by the 2026 rebrand, mirroring the
/// web's `.btn-primary` / `.btn-outline` / `.btn-accent` utility classes in
/// styles/globals.css on the flutterconKE2024Web repo — see
/// docs/design/REBRAND-PLAN.md.
///
/// These are opt-in builders, not wired into `ThemeData`'s
/// `elevatedButtonTheme`/`outlinedButtonTheme` defaults — doing so would
/// restyle every existing button app-wide as a side effect of this
/// (foundation-only) phase. Screens adopt these explicitly as they're
/// migrated (Phase 1 onward).
///
/// The web variants render their label text uppercase via a CSS class;
/// Flutter's `TextStyle` has no text-transform equivalent, so callers must
/// uppercase the label string themselves (e.g. `label.toUpperCase()`)
/// rather than relying on these styles to do it.
class AppButtonStyles {
  AppButtonStyles._();

  static const _labelStyle = TextStyle(
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const _padding = EdgeInsets.symmetric(horizontal: 32, vertical: 14);

  /// Solid brand-blue pill button. Matches `.btn-primary`.
  static ButtonStyle primary(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: ThemeColors.flutterconBlue,
      foregroundColor: Colors.white,
      textStyle: _labelStyle,
      padding: _padding,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: Corners.pillBorder),
    );
  }

  /// Solid brand-magenta pill button, black label. Matches `.btn-accent`.
  static ButtonStyle accent(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: ThemeColors.flutterconMagenta,
      foregroundColor: Colors.black,
      textStyle: _labelStyle,
      padding: _padding,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: Corners.pillBorder),
    );
  }

  /// Transparent pill button with a hairline border. Matches `.btn-outline`.
  static ButtonStyle outline(BuildContext context) {
    final (_, colorScheme) = Misc.getTheme(context);

    return OutlinedButton.styleFrom(
      foregroundColor: colorScheme.onSurface,
      textStyle: _labelStyle,
      padding: _padding,
      side: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.3)),
      shape: RoundedRectangleBorder(borderRadius: Corners.pillBorder),
    );
  }
}
