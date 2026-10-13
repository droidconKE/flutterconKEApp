import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/sponsor_type.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/dashed_divider.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/common/widgets/status_view.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/features/home/cubit/fetch_sponsors_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';

/// Tiers that get their own named section, in display order. Anything not
/// in this list (swag/startup/venue/etc.) is still shown, grouped with
/// "everything else" after silver/bronze — mirrors the web's
/// `SponsorsList.tsx` (`REMAINING_TIER_ORDER`), minus its platinum/gold
/// special-casing which collapses into the same per-tier section here.
const _tierDisplayOrder = [
  SponsorType.platinum,
  SponsorType.gold,
  SponsorType.silver,
  SponsorType.bronze,
  SponsorType.swag,
  SponsorType.startup,
  SponsorType.venue,
];

String _tierLabel(SponsorType type) {
  final name = type.name;
  return name[0].toUpperCase() + name.substring(1);
}

class SponsorsCard extends StatefulWidget {
  const SponsorsCard({super.key});

  @override
  State<SponsorsCard> createState() => _SponsorsCardState();
}

class _SponsorsCardState extends State<SponsorsCard> {
  @override
  void initState() {
    context.read<FetchSponsorsCubit>().fetchSponsors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: Corners.s24Border,
        color: colorScheme.secondaryContainer,
        border: Border.all(color: colorScheme.primary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            l10n.sponsors,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<FetchSponsorsCubit, FetchSponsorsState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (sponsors) {
                if (sponsors.isEmpty) {
                  return const SizedBox.shrink();
                }

                final tiersPresent = _tierDisplayOrder
                    .where(
                      (tier) => sponsors.any(
                        (sponsor) => sponsor.sponsorType == tier,
                      ),
                    )
                    .toList();
                final knownTiers = _tierDisplayOrder.toSet();
                final otherTiers = sponsors
                    .map((sponsor) => sponsor.sponsorType)
                    .where((tier) => !knownTiers.contains(tier))
                    .toSet();

                return Column(
                  children: [
                    for (final tier in [...tiersPresent, ...otherTiers])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: [
                            DashedDivider(
                              color: isLightMode
                                  ? ThemeColors.greyAccentColor
                                  : ThemeColors.lightGreyTextColor,
                            ),
                            const SizedBox(height: 16),
                            AutoSizeText(
                              _tierLabel(tier),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: sponsors
                                  .where(
                                    (sponsor) => sponsor.sponsorType == tier,
                                  )
                                  .map(
                                    (sponsor) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isLightMode
                                            ? ThemeColors
                                                  .lightGrayBackgroundColor
                                            : Colors.white,
                                        borderRadius: Corners.s16Border,
                                      ),
                                      child: ResolvedImage(
                                        imageUrl: sponsor.logo,
                                        height: tier == SponsorType.platinum
                                            ? 56
                                            : 40,
                                        width: tier == SponsorType.platinum
                                            ? 160
                                            : 120,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
              error: (message) => StatusView(
                icon: Icons.wifi_off_rounded,
                title: l10n.sponsorsErrorTitle,
                message: message,
                onRetry: () => context.read<FetchSponsorsCubit>().fetchSponsors(
                  forceRefresh: true,
                ),
              ),
              orElse: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
