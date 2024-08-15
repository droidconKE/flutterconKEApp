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
                'Droidcon is a global conference focused on the engineering'
                ' of Android applications. Droidcon provides a forum for '
                'developers to network with other developers, share '
                'techniques, announce apps and products, and to learn and '
                'teach.\n\n'
                'This three-day developer focused gathering will be held '
                'in Nairobi Kenya on November 16th to 18th 2022 and will '
                'be the largest of its kind in Africa.\n\n'
                'It will have workshops and codelabs focused on the '
                'building of Android applications and will give '
                'participants an excellent chance to learn about the local '
                'Android development ecosystem, opportunities and services '
                'as well as meet the engineers and companies who work on '
                'them.',
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
