import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/features/home/widgets/organizers_card.dart';
import 'package:fluttercon/features/home/widgets/speaker_card.dart';
import 'package:fluttercon/features/home/widgets/sponsors_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                'Welcome to the largest Focused Android Developer community '
                'in Africa',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(AppAssets.droidconBanner),
              ),
              const SizedBox(height: 24),
              const SpeakerCard(),
              const SizedBox(height: 24),
              const SponsorsCard(),
              const SizedBox(height: 24),
              const OrganizersCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
