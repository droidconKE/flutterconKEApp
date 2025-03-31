import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:fluttercon/common/utils/notification_service.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/core/theme/theme_data.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          themeMode: getIt<HiveRepository>().retrieveThemeMode(),
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: getIt<FlutterConRouter>().config(),
        );
      },
    );
  }
}
