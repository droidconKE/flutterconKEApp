import 'package:flutter/material.dart';

import '../../core/navigator/route_names.dart';
import '../../common/utils/constants/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    nextAction();
  }

  void nextAction() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.dashboard,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.imgDroidcon),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
