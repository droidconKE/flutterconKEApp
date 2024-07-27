import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/core/navigator/route_names.dart';

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

  Future<void> nextAction() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (!mounted) return;
    await Navigator.pushNamedAndRemoveUntil(
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
