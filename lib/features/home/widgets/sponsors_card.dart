import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/sponsor_type.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/features/home/cubit/fetch_sponsors_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:sizer/sizer.dart';

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
    final size = MediaQuery.sizeOf(context);
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Container(
      width: double.infinity,
      height: size.height * .35,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.secondaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            l10n.sponsors,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              fontSize: 18,
            ),
          ),
          BlocBuilder<FetchSponsorsCubit, FetchSponsorsState>(
            builder:
                (context, state) => state.maybeWhen(
                  loaded: (sponsors) {
                    final nonPlatinumSponsors =
                        sponsors
                            .where(
                              (sponsor) =>
                                  sponsor.sponsorType != SponsorType.gold,
                            )
                            .toList();
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            color:
                                isLightMode
                                    ? colorScheme.secondaryContainer
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  isLightMode
                                      ? Colors.transparent
                                      : colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: ResolvedImage(
                            imageUrl:
                                sponsors
                                    .firstWhere(
                                      (sponsor) =>
                                          sponsor.sponsorType ==
                                          SponsorType.gold,
                                    )
                                    .logo,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: size.height / 10,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: nonPlatinumSponsors.length,
                            itemBuilder:
                                (context, index) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isLightMode
                                            ? colorScheme.secondaryContainer
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          isLightMode
                                              ? Colors.transparent
                                              : colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: size.width / 4,
                                    child: ResolvedImage(
                                      imageUrl: nonPlatinumSponsors[index].logo,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                  error:
                      (message) => AutoSizeText(
                        message,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          fontSize: 18,
                        ),
                      ),
                  orElse:
                      () => const Center(child: CircularProgressIndicator()),
                ),
          ),
        ],
      ),
    );
  }
}
