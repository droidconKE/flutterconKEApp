import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/organising_team.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';

import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/about/cubit/fetch_organising_team_cubit.dart';
import 'package:fluttercon/features/about/widgets/organizing_team_card.dart';
import 'package:fluttercon/features/home/widgets/organizers_card.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.light;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AppAssets.teamPhoto),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark
                          ? ThemeColors.tealColor
                          : ThemeColors.blueDroidconColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Fluttercon Kenya is the first event of its kind in Africa,'
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
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Organizing Team',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark
                          ? ThemeColors.tealColor
                          : ThemeColors.blueDroidconColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            //individualOrganizers
            BlocProvider(
              create: (context) => FetchOrganisingTeamCubit(
                apiRepository: ApiRepository(),
              ),
              child: const OrganisingTeamCard(),
            ),
            const SizedBox(height: 20),
            const OrganizersCard(),
          ],
        ),
      ),
    );
  }
}
