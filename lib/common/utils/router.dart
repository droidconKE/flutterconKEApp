import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/session.dart';
import 'package:fluttercon/features/auth/ui/sign_in.dart';
import 'package:fluttercon/features/dashboard/ui/dashboard_screen.dart';
import 'package:fluttercon/features/home/ui/speakers_list_screen.dart';
import 'package:fluttercon/features/sessions/ui/session_details/session_details.dart';
import 'package:fluttercon/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class FlutterConRouter {
  static GoRouter get router => _router;

  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';
  static const String dashboardRoute = '/dashboard';
  static const String speakerListRoute = 'speakers';
  static const String sessionDetailsRoute = '/session-details';

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
        routes: [
          GoRoute(
            path: speakerListRoute,
            name: speakerListRoute,
            builder: (context, state) => const SpeakerListScreen(),
          ),
        ],
      ),
      GoRoute(
        path: sessionDetailsRoute,
        name: sessionDetailsRoute,
        builder: (context, state) => SessionDetailsPage(
          session: state.extra! as Session,
        ),
      ),
    ],
  );
}
