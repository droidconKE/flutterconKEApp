import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/l10n/l10n.dart';

/// Matches the web's "2026 Conf. Essentials" block on the homepage
/// (flutterconKE2024Web `dev` branch) — a blue/magenta gradient card with
/// the four conference pillars, topped by a "More Stacks. All Mobile."
/// strip of the supported platform/tech logos.
class ConfEssentialsCard extends StatelessWidget {
  const ConfEssentialsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColorRamps.blue700, ThemeColors.flutterconMagenta],
            ),
            borderRadius: Corners.s24Border,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.confEssentialsTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _EssentialItem(
                    icon: AppAssets.svgPanels,
                    label: l10n.essentialPanels,
                  ),
                  _EssentialItem(
                    icon: AppAssets.svgWorkshops,
                    label: l10n.essentialWorkshops,
                  ),
                  _EssentialItem(
                    icon: AppAssets.svgNetworking,
                    label: l10n.essentialNetworking,
                  ),
                  _EssentialItem(
                    icon: AppAssets.svgExhibitions,
                    label: l10n.essentialExhibitions,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Corners.s24Border,
              border: Border.all(color: AppColorRamps.blue700),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.moreStacksAllMobile,
                  style: const TextStyle(
                    color: AppColorRamps.blue700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Wrap(
                  spacing: Sizes.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final asset in [
                      AppAssets.svgKotlin,
                      AppAssets.svgSwift,
                      AppAssets.svgAi,
                      AppAssets.svgFlutter,
                    ])
                      SizedBox.square(
                        dimension: IconSizes.stack,
                        child: SvgPicture.asset(asset),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EssentialItem extends StatelessWidget {
  const _EssentialItem({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(
          dimension: IconSizes.essential,
          child: SvgPicture.asset(icon),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
