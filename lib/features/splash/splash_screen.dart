import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _redirectToPage(
    BuildContext context,
    String routeName,
  ) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => GoRouter.of(context).goNamed(routeName),
    );
  }

  @override
  void initState() {
    // Go directly to the landing page
    _redirectToPage(
      context,
      FlutterConRouter.dashboardRoute,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final (_, colorScheme) = Misc.getTheme(context);
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: const Center(
        child: Image(
          image: AssetImage(AppAssets.imgDroidcon),
        ),
      ),
    );
  }
}
