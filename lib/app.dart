import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'common/theme/bloc/theme_bloc.dart';
import 'fluttercon/bloc/fluttercon_bloc.dart';
import 'navigator/main_navigator.dart';

class FlutterconApp extends StatefulWidget {
  final Widget? home;
  const FlutterconApp({super.key, this.home});

  @override
  State<FlutterconApp> createState() => FlutterconAppState();
}

class FlutterconAppState extends State<FlutterconApp> {
  final navigatorKey = MainNavigatorState.navigationKey;
  NavigatorState get navigator =>
      MainNavigatorState.navigationKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => FlutterconBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state.status == ThemeStatus.initial) {
            context.read<ThemeBloc>().add(ThemeChangeEvent());
          }
          return MaterialApp(
            title: 'Fluttercon 2024',
            themeMode: state.themeType == ThemeType.system
                ? ThemeMode.system
                : (state.themeType == ThemeType.light
                    ? ThemeMode.light
                    : ThemeMode.dark),
            //theme: theme,
            //darkTheme: darkTheme,
            home: widget.home,
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
      ),
    );
  }
}
