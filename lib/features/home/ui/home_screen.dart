import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/widgets/app_bar/app_bar.dart';
import 'package:fluttercon/features/home/widgets/organizers_card.dart';
import 'package:fluttercon/features/home/widgets/sessions_card.dart';
import 'package:fluttercon/features/home/widgets/speaker_home_card.dart';
import 'package:fluttercon/features/home/widgets/sponsors_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.switchTab});

  final VoidCallback? switchTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(selectedIndex: 0),
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
                      color: Colors.black,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(AppAssets.flutterConBanner),
              ),
              const SizedBox(height: 24),
              SessionsCard(switchTab: widget.switchTab),
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
