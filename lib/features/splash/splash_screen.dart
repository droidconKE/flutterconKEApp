import 'package:flutter/material.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/di/injectable.dart';
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
    final accessToken = getIt<HiveRepository>().retrieveToken();

    if (accessToken == null) {
      _redirectToPage(
        context,
        FlutterConRouter.signInRoute,
      );
    } else {
      _redirectToPage(
        context,
        FlutterConRouter.dashboardRoute,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(AppAssets.imgDroidcon),
        ),
      ),
    );
  }
}
