import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/local/local_individual_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/features/about/ui/organising_team_details.dart';
import 'package:fluttercon/features/auth/ui/sign_in.dart';
import 'package:fluttercon/features/dashboard/ui/dashboard_screen.dart';
import 'package:fluttercon/features/feedback/ui/feedback_screen.dart';
import 'package:fluttercon/features/home/ui/speaker_details/speaker_details.dart';
import 'package:fluttercon/features/home/ui/speakers_list_screen.dart';
import 'package:fluttercon/features/sessions/ui/session_details/session_details.dart';
import 'package:fluttercon/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@singleton
class FlutterConRouter {
  static GoRouter get router => _router;

  static const String decisionRoute = '/';
  static const String signInRoute = '/sign-in';
  static const String dashboardRoute = '/dashboard';
  static const String speakerListRoute = 'speakers';
  static const String sessionDetailsRoute = '/session-details';
  static const String speakerDetailsRoute = '/speaker-details';
  static const String organiserDetailsRoute = '/organiser-details';
  static const String feedbackRoute = '/feedback';

  GoRouter config() => router;

  static GlobalKey<NavigatorState> get globalNavigatorKey =>
      GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    initialLocation: decisionRoute,
    navigatorKey: globalNavigatorKey,
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
          session: state.extra! as LocalSession,
        ),
      ),
      GoRoute(
        path: speakerDetailsRoute,
        name: speakerDetailsRoute,
        builder: (context, state) => SpeakerDetailsPage(
          speaker: state.extra! as LocalSpeaker,
        ),
      ),
      GoRoute(
        path: organiserDetailsRoute,
        name: organiserDetailsRoute,
        builder: (context, state) => OranisingTeamMemberDetailsPage(
          organiser: state.extra! as LocalIndividualOrganiser,
        ),
      ),
      GoRoute(
        path: feedbackRoute,
        name: feedbackRoute,
        builder: (context, state) => FeedbackScreen(
          sessionSlug: state.extra as String?,
        ),
      ),
    ],
  );
}
