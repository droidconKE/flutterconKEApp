import 'package:flutter/material.dart';
import 'package:fluttercon/features/auth/ui/sign_in.dart';
import 'package:fluttercon/features/dashboard/ui/dashboard_screen.dart';
import 'package:fluttercon/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class FlutterConRouter {
  static GoRouter get router => _router;

  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';
  static const String dashboardRoute = '/dashboard';

  static final GlobalKey<NavigatorState> _globalNavigatorKey =
      GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    initialLocation: decisionRoute,
    navigatorKey: _globalNavigatorKey,
    routes: [
      GoRoute(
        path: decisionRoute,
        name: decisionRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: signInRoute,
        name: signInRoute,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: dashboardRoute,
        name: dashboardRoute,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
