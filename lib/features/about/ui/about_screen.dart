import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';

import 'package:fluttercon/core/theme/theme_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.light;
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDark
                              ? ThemeColors.tealColor
                              : ThemeColors.blueDroidconColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Droidcon is a global conference focused on the engineering of Android applications. Droidcon provides a forum for developers to network with other developers, share techniques, announce apps and products, and to learn and teach.\n\n'
                    'This three-day developer focused gathering will be held in Nairobi Kenya on November 16th to 18th 2022 and will be the largest of its kind in Africa.\n\n'
                    'It will have workshops and codelabs focused on the building of Android applications and will give participants an excellent chance to learn about the local Android development ecosystem, opportunities and services as well as meet the engineers and companies who work on them.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Organizing Team',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDark
                              ? ThemeColors.tealColor
                              : ThemeColors.blueDroidconColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  //individualOrganizers
                  const SizedBox(height: 40),
                  const OrganizersCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
