import 'package:flutter/material.dart';
import 'package:fluttercon/core/theme/inverted_panel_theme.dart';
import 'package:fluttercon/core/theme/text_styles.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';

class _Stat {
  const _Stat(this.value, this.label);

  final String value;
  final String label;
}

/// The 2x2 stat block from the web's `components/home/About.tsx` (flutterconKE2024Web,
/// `dev` branch) — see docs/design/REBRAND-PLAN.md, Phase 2 (flutterconKEApp#259).
///
/// Deliberately inverts color between light and dark mode: black background with
/// magenta figures in light mode, magenta background with white figures in dark
/// mode. That's the [InvertedPanelColors] theme extension from Phase 0, not a
/// hardcoded swap here — see lib/core/theme/inverted_panel_theme.dart.
class AboutStatsPanel extends StatelessWidget {
  const AboutStatsPanel({super.key});

  static const _stats = [
    _Stat('3RD', 'FLUTTERCON EDITION'),
    _Stat('7TH', 'DROIDCON EDITION'),
    _Stat('230+', 'SESSIONS DELIVERED'),
    _Stat('3,000+', 'ATTENDEES SINCE 2018'),
  ];

  @override
  Widget build(BuildContext context) {
    final panelColors = Theme.of(context).extension<InvertedPanelColors>()!;

    return ClipRRect(
      borderRadius: Corners.s24Border,
      child: ColoredBox(
        color: panelColors.background,
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.4,
          children: [
            for (var i = 0; i < _stats.length; i++)
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                decoration: i < 2
                    ? const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ThemeColors.flutterconBlue),
                        ),
                      )
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _stats[i].value,
                      style: AppTextStyles.display(
                        fontSize: 28,
                        color: panelColors.figure,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _stats[i].label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: panelColors.figure,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
