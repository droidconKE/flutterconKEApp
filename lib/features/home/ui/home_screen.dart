import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/widgets/organizers_card.dart';
import 'package:fluttercon/features/home/widgets/sponsors_card.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                'Welcome to the largest Focused Android Developer community in Africa',
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThemeColors.tealColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.cfsBanner,
                      width: 20.w,
                      height: 10.h,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Call for Speakers',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                  ),
                        ),
                        Text(
                          'Apply to be a speakers',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                  ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const ImageIcon(
                      AssetImage(AppAssets.playIcon),
                      color: Colors.white,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
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
