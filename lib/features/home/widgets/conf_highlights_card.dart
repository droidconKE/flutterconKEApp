import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/l10n/l10n.dart';

/// Matches the web's "Conf. Highlights" homepage section
/// (flutterconKE2024Web `dev` branch) — two full-bleed highlight cards,
/// "Beyond the Sessions" (blue) and "Developer Days" (black/magenta).
class ConfHighlightsCard extends StatelessWidget {
  const ConfHighlightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.confHighlightsTitle,
          style: const TextStyle(
            color: AppColorRamps.blue700,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _HighlightTile(
          image: AppAssets.beyondSessions,
          title: l10n.beyondSessionsTitle,
          description: l10n.beyondSessionsDescription,
          background: AppColorRamps.blue700,
          titleColor: Colors.white,
        ),
        const SizedBox(height: 16),
        _HighlightTile(
          image: AppAssets.devDays,
          title: l10n.developerDaysTitle,
          description: l10n.developerDaysDescription,
          background: ThemeColors.blackColor,
          titleColor: ThemeColors.flutterconMagenta,
        ),
      ],
    );
  }
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({
    required this.image,
    required this.title,
    required this.description,
    required this.background,
    required this.titleColor,
  });

  final String image;
  final String title;
  final String description;
  final Color background;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: Corners.s24Border,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Image.asset(image, fit: BoxFit.contain)),
        ],
      ),
    );
  }
}
