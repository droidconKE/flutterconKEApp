import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';

import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/about/cubit/fetch_individual_organisers_cubit.dart';
import 'package:fluttercon/features/about/ui/organising_team.dart';
import 'package:fluttercon/features/home/widgets/organizers_card.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    context.read<FetchIndividualOrganisersCubit>().fetchIndividualOrganisers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Image.asset(AppAssets.teamPhoto)),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'About',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ThemeColors.blueDroidconColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Fluttercon Kenya is the first event of its kind in Africa, '
                'launching the Fluttercon conference on the continent. It '
                'will feature tech talks, workshops, and panels led by '
                'industry experts, Google Developer Experts, and seasoned '
                'Flutter specialists, all focusing on the latest '
                'advancements in Flutter and Dart technologies.\n\n'
                'Organized by the same team behind four successful editions'
                ' of Droidcon Kenya, Fluttercon Kenya promises to maintain '
                'a high standard of excellence. With a history of hosting '
                'over 3,000 attendees and curating 200 sessions, the team '
                'brings unmatched expertise to this event.\n\n'
                "Co-located with Droidcon Kenya, Africa's top Android "
                'developer conference, Fluttercon Kenya will run from '
                'November 6th to 8th, 2024. The joint event will gather '
                'hundreds of Flutter and Android developers, offering a '
                'packed program of tech talks, workshops, and panels, '
                "forming one of the continent's largest mobile developer "
                'gatherings.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Organizing Team',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ThemeColors.blueDroidconColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const OrganisingTeamView(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: OrganizersCard(),
            ),
          ),
        ],
      ),
    );
  }
}
