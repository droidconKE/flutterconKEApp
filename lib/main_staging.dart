import 'package:flutter/material.dart';
import 'package:fluttercon/app.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterConConfig(
    values: FlutterConValues(
      baseDomain: 'api.droidcon.co.ke',
      urlScheme: 'https',
    ),
  );

  await configureDependencies();

  bootstrap(() => const MyApp());
}