import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';

/// Which pill variant to render. Matches the web's `levelPill`/`formatPill`
/// classes in `components/sessions/SessionListCard.tsx` on the
/// flutterconKE2024Web repo — see docs/design/REBRAND-PLAN.md. Session level
/// (e.g. "Beginner", "Keynote") is magenta; session format (e.g. "Talk",
/// "Workshop") is blue.
enum PillBadgeVariant { level, format }

/// A small rounded-full label chip introduced by the 2026 rebrand's
/// pill-badge language. Not yet wired into any screen — Phase 3
/// (flutterconKEApp#260) adopts this on session/speaker cards.
class PillBadge extends StatelessWidget {
  const PillBadge({required this.label, required this.variant, super.key});

  final String label;
  final PillBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (isLightMode, _) = Misc.getTheme(context);

    final Color background;
    final Color foreground;
    switch (variant) {
      case PillBadgeVariant.level:
        background = isLightMode
            ? AppColorRamps.magenta100
            : AppColorRamps.magenta500.withValues(alpha: 0.15);
        foreground = isLightMode
            ? AppColorRamps.magenta800
            : ThemeColors.flutterconMagenta;
      case PillBadgeVariant.format:
        background = isLightMode
            ? AppColorRamps.blue50
            : ThemeColors.flutterconBlue.withValues(alpha: 0.2);
        foreground = isLightMode
            ? ThemeColors.flutterconBlue
            : AppColorRamps.blue300;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: Corners.pillBorder,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
