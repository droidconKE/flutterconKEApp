import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercon/app.dart';
import 'package:fluttercon/bootstrap.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  FlutterConConfig(
    values: FlutterConValues(
      baseDomain: 'api.droidcon.co.ke',
      urlScheme: 'https',
      hiveBox: 'fluttercon-prod',
      eventSlug: 'flutterconke24-252',
      organiserSlug: 'flutterconke-571',
    ),
  );
  tz.initializeTimeZones();
  await bootstrap(() => const MyApp());
}
