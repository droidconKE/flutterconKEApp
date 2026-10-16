# Notifications

*Last verified: 2026-09-11, against `feat/2026_rebrand`. Source: `lib/common/utils/notification_service.dart`.*

Uses **`awesome_notifications`**, not `flutter_local_notifications` — the latter is still a
`pubspec.yaml` dependency but appears unused for this purpose; check for other usages before assuming
it's load-bearing anywhere.

## Setup

`NotificationService` (`@singleton`) is initialized in `bootstrap.dart`: `requestPermission()` (asks
for OS permission if not already granted) then `initNotifications()`, which registers exactly one
channel, `session_channel` (high importance, sound + vibration + the app's blue as its color). If a new
notification *type* is needed, it needs its own channel added here — the whole notification system is
built around this single channel today.

## What schedules a notification

The only trigger in the codebase is bookmarking a session. `BookmarkSessionCubit.bookmarkSession()`
(`lib/features/sessions/cubit/bookmark_session_cubit.dart`) calls
`NotificationService.createScheduledNotification(session: ..., channelKey: 'session_channel')` when a
session transitions to bookmarked (not on un-bookmark).

`createScheduledNotification` (`notification_service.dart:51-82`) schedules for
**`session.endDateTime - 5 minutes`** (i.e. fires near the end of the talk, not at bookmark time), with
title `"<session title> feedback"` and body prompting the user to submit feedback, `payload:
{'sessionSlug': session.slug}`. The notification's `id` is the session's local Isar id (`session.id`),
so re-bookmarking the same session re-schedules under the same id (overwrites rather than duplicates).
There's a commented-out line for testing with a 5-second delay instead — leave it commented in shipped
code, uncomment only for local manual testing.

## Deep link on tap

`app.dart`'s `MyApp.initState()` wires `AwesomeNotifications().setListeners(onActionReceivedMethod:
NotificationService.onActionReceivedMethod)`. That static callback
(`notification_service.dart:84-97`, annotated `@pragma('vm:entry-point')` so it survives tree-shaking
and works when the app is launched cold from a notification tap) switches on `channelKey` — currently
only handles `'session_channel'` — and pushes `FlutterConRouter.feedbackRoute` with the payload's
`sessionSlug` as `extra`, landing the user on `FeedbackScreen` pre-scoped to that session. Adding a
second notification type means adding both a new channel (above) and a new `case` here.
