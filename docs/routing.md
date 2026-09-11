# Routing

*Last verified: 2026-09-11, against `feat/2026_rebrand`. Source: `lib/common/utils/router.dart`.*

`FlutterConRouter` is a `@singleton` wrapping a single `static final GoRouter _router`, exposed to the
app via `config()` and consumed in `lib/app.dart` as `MaterialApp.router(routerConfig: ...)`.

## Route table

| Path | Name constant | Screen | Data passed |
|---|---|---|---|
| `/` | `decisionRoute` | `SplashScreen` | — |
| `/sign-in` | `signInRoute` | `SignInScreen` | — |
| `/dashboard` | `dashboardRoute` | `DashboardScreen` | — |
| `/dashboard/speakers` | `speakerListRoute` (child of dashboard) | `SpeakerListScreen` | — |
| `/session-details` | `sessionDetailsRoute` | `SessionDetailsPage` | `state.extra` as `LocalSession` (required, force-unwrapped) |
| `/speaker-details` | `speakerDetailsRoute` | `SpeakerDetailsPage` | `state.extra` as `LocalSpeaker` (required) |
| `/organiser-details` | `organiserDetailsRoute` | `OranisingTeamMemberDetailsPage` | `state.extra` as `LocalIndividualOrganiser` (required) |
| `/feedback` | `feedbackRoute` | `FeedbackScreen` | `state.extra` as `String?` (optional `sessionSlug`) |

Because `session-details`/`speaker-details`/`organiser-details` force-unwrap `state.extra`, navigating
to them via a raw URL (e.g. a deep link, or `context.go('/session-details')` without `extra:`) will throw.
These routes are only ever meant to be reached via in-app `context.go(route, extra: theObject)` calls
that already hold the object — they are not designed to reconstruct state from a URL/id.

## No auth guard

There is no `redirect:` callback anywhere in the `GoRouter` config. `SplashScreen.initState()`
(`lib/features/splash/splash_screen.dart:20-26`) unconditionally calls
`GoRouter.of(context).goNamed(FlutterConRouter.dashboardRoute)` after the first frame — its own comment
says "Go directly to the landing page." It does not check `HiveRepository.retrieveToken()` or any auth
state. Practical effect: **unauthenticated users land straight on the dashboard**; sign-in is only
reached by explicitly navigating to `signInRoute` from somewhere in the UI (e.g. a profile/settings
affordance), not enforced by the router. If a task says "add an auth check to routing," this is the
file and the exact behavior to change — there's nothing partially built to extend, it's a clean
insertion point.

## Dashboard tabs are not routes

`DashboardScreen` (`lib/features/dashboard/ui/dashboard_screen.dart`) is a plain `StatefulWidget` with
its own `PageController`/`PageView` and a `CustomBottomNavigationBar`
(`lib/common/widgets/bottom_nav/bottom_nav_bar.dart`) cycling through 4 `PageItem`s: Home, Feed,
Sessions, About. Switching tabs calls in-widget methods (`switchTab`/`jumpToPage`) and never touches
`GoRouter` — the URL/route stack doesn't reflect which tab is active, and there is no deep link into a
specific tab. If a task needs "link directly to the Sessions tab," that requires adding state (e.g. a
query param or a new nested route) — it doesn't exist today.

## `globalNavigatorKey` is not actually stable

`FlutterConRouter.globalNavigatorKey` is a `static GlobalKey<NavigatorState> get` — because it's a
getter with `GlobalKey<NavigatorState>()` in its body rather than a cached `static final` field, **every
read returns a brand new key**. The router itself only uses the value captured once at its own static
initialization (`navigatorKey: globalNavigatorKey` inside the `_router` field initializer, evaluated
once), so routing itself works fine — but any *other* code that reads `FlutterConRouter.globalNavigatorKey`
expecting to get the router's actual navigator key back will get a different, useless key each time.
Don't use this getter to reach the app's navigator from elsewhere; if that's needed, it should be
refactored to a cached field first.
