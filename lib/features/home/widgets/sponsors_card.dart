import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/sponsor_type.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/resolved_image.dart';
import 'package:fluttercon/features/home/cubit/fetch_sponsors_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';

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
    final (_, colorScheme) = Misc.getTheme(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height / 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.secondaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            l10n.sponsors,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              fontSize: 18,
            ),
          ),
          BlocBuilder<FetchSponsorsCubit, FetchSponsorsState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (sponsors) {
                final nonPlatinumSponsors = sponsors
                    .where(
                      (sponsor) =>
                          SponsorType.fromValue(sponsor.sponsorType) !=
                          SponsorType.platinum,
                    )
                    .toList();
                return Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: ResolvedImage(
                        imageUrl: sponsors
                            .firstWhere(
                              (sponsor) =>
                                  SponsorType.fromValue(sponsor.sponsorType) ==
                                  SponsorType.platinum,
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
                        itemBuilder: (context, index) => SizedBox(
                          width: (size.width / 4).clamp(50, 150),
                          child: ResolvedImage(
                            imageUrl: nonPlatinumSponsors[index].logo,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (message) => Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      fontSize: 18,
                    ),
              ),
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
