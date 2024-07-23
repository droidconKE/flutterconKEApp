import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/theme_data.dart';
import 'core/local_storage.dart';
import 'core/di/injectable.dart';
import 'core/navigator/main_navigator.dart';

class MyApp extends StatefulWidget {
  final Widget? home;
  const MyApp({super.key, this.home});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final navigatorKey = MainNavigatorState.navigationKey;
  NavigatorState get navigator =>
      MainNavigatorState.navigationKey.currentState!;

  @override
  Widget build(BuildContext context) {
    var localStorage = getIt<LocalStorage>();

    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return Sizer(
            builder: (context, orientation, deviceType) {
              return MaterialApp(
                home: widget.home,
                themeMode: localStorage.getThemeMode(),
                theme: AppTheme.lightTheme(),
                darkTheme: AppTheme.darkTheme(),
                supportedLocales: const [Locale('en'), Locale('sw')],
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                initialRoute: MainNavigatorState.initialRoute,
                onGenerateRoute: MainNavigatorState.onGenerateRoute,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              );
            },
          );
        },
      ),
    );
  }
}
