import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/enums/sponsor_type.dart';
import 'package:fluttercon/common/data/models/local/local_sponsor.dart';

import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/cubit/fetch_sponsors_cubit.dart';

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
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height / 4,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ThemeColors.lightGrayColor,
      ),
      child: Column(
        children: [
          const Spacer(),
          const Text(
            'Sponsors',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ThemeColors.blueColor,
              fontSize: 18,
            ),
          ),
          const Spacer(),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: resolveImage(
                        sponsors.firstWhere(
                          (sponsor) =>
                              SponsorType.fromValue(sponsor.sponsorType) ==
                              SponsorType.platinum,
                        ),
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
                          width: size.width / 4,
                          child: resolveImage(nonPlatinumSponsors[index]),
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
                      color: ThemeColors.blueColor,
                      fontSize: 18,
                    ),
              ),
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget resolveImage(LocalSponsor sponsor) {
    return sponsor.logo.contains('.svg')
        ? SvgPicture.network(sponsor.logo)
        : CachedNetworkImage(imageUrl: sponsor.logo);
  }
}
