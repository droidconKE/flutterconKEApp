import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:intl/intl.dart';

/// The rounded time-badge box from the web's `SessionListCard.tsx`
/// (flutterconKE2024Web, `dev` branch) — see docs/design/REBRAND-PLAN.md,
/// Phase 3 (flutterconKEApp#260). A small rounded-2xl box showing the
/// session start time with AM/PM stacked below it.
class SessionTimeBadge extends StatelessWidget {
  const SessionTimeBadge({required this.startDateTime, super.key});

  final DateTime startDateTime;

  @override
  Widget build(BuildContext context) {
    final (isLightMode, _) = Misc.getTheme(context);

    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isLightMode
            ? AppColorRamps.blue50
            : ThemeColors.flutterconBlue.withValues(alpha: 0.15),
        borderRadius: Corners.s16Border,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('h:mm').format(startDateTime),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1,
              color: isLightMode
                  ? ThemeColors.flutterconBlue
                  : ThemeColors.flutterconMagenta,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('a').format(startDateTime),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isLightMode
                  ? ThemeColors.greyTextColor
                  : ThemeColors.lightGreyTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
