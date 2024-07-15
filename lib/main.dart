import 'package:flutter/material.dart';

import 'app.dart';
import 'common/utils/env/flavor_config.dart';
import 'common/utils/env/environments.dart';
import 'common/utils/logger.dart';
import 'core/di/injectable.dart';

// starting the app with debug options
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig(
    flavor: Flavor.dev,
    name: 'DEV',
    color: Colors.red,
    values: const FlavorValues(
      logNetworkInfo: true,
      showFullErrorMessages: true,
    ),
  );

  logger('Starting app from main.dart');

  await configureDependencies(Environments.dev);

  runApp(const MyApp());
}
