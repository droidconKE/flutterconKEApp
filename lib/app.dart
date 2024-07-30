import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/core/local_storage.dart';
import 'package:fluttercon/core/theme/bloc/theme_bloc.dart';
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
  Widget build(BuildContext context) {
    final localStorage = getIt<LocalStorage>();

    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp.router(
                themeMode: localStorage.getThemeMode(),
                theme: AppTheme.lightTheme(),
                darkTheme: AppTheme.darkTheme(),
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: FlutterConRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
