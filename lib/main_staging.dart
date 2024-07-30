import 'package:flutter/material.dart';
import 'package:fluttercon/app.dart';
import 'package:fluttercon/bootstrap.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterConConfig(
    values: FlutterConValues(
      baseDomain: 'api.droidcon.co.ke',
      urlScheme: 'https',
      hiveBox: 'fluttercon-stg',
    ),
  );

  await bootstrap(() => const MyApp());
}
