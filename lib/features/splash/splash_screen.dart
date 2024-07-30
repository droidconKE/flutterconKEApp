import 'package:flutter/material.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
      (_) => Navigator.of(context).pushReplacementNamed(routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<dynamic>(FlutterConConfig.instance!.values.hiveBox)
              .listenable(),
      builder: (context, _, __) {
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
        return const Scaffold(
          body: Center(
            child: Image(
              image: AssetImage(AppAssets.imgDroidcon),
            ),
          ),
        );
      },
    );
  }
}
