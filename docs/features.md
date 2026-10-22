# Features

*Last verified: 2026-09-11, against `feat/2026_rebrand`. File lists below exclude generated `.g.dart`/`.freezed.dart`.*

Each feature module under `lib/features/<name>/` typically has `cubit/` (Cubit + freezed state),
`ui/` (screens), and sometimes `widgets/` (feature-local widgets). None of these Cubits are DI-registered
— they're constructed in `lib/bootstrap.dart`'s `MultiBlocProvider` (see [architecture.md](architecture.md)).

## `splash`

- `ui/splash_screen.dart` — the `/` route. Currently navigates straight to the dashboard route on the
  first frame; does not check auth state (see [routing.md](routing.md) for why).

## `dashboard`

- `ui/dashboard_screen.dart` — hosts the 4-tab bottom nav (Home, Feed, Sessions, About) via its own
  `PageController`/`PageView`, **not** a go_router `ShellRoute`. Tab switching doesn't touch the route
  stack.

## `home`

Despite the name, this module owns most of the dashboard's first-tab *data* fetching, not just the
home screen UI:

- `cubit/fetch_sessions_cubit.dart`, `fetch_organisers_cubit.dart`, `fetch_speakers_cubit.dart`,
  `fetch_sponsors_cubit.dart` — each follows the cache-first pattern from
  [data-layer.md](data-layer.md) for its respective content type.
- `cubit/home_cubits.dart` — barrel file re-exporting the above cubits/states.
- `cubit/search_cubit.dart` — Isar-only search across sessions/speakers/individual organisers (see
  `DBRepository.searchSessions`/`searchSpeakers`/`searchIndividualOrganisers`); never touches the network.
- `ui/home_screen.dart` — the Home tab: sponsor/session/speaker preview cards.
- `ui/speakers_list_screen.dart`, `ui/speaker_details/speaker_details.dart` — full speaker list and
  detail page (reached via `/dashboard/speakers` and `/speaker-details`, see [routing.md](routing.md)).
- `widgets/` — `organizers_card.dart`, `search_bar.dart`, `sessions_card.dart`, `speaker_grid_tile.dart`,
  `speaker_home_card.dart`, `sponsors_card.dart` — presentational cards used on the home screen.

## `sessions`

- `cubit/fetch_grouped_sessions_cubit.dart` — sessions grouped (by day/time) for the schedule view,
  cache-first pattern.
- `cubit/bookmark_session_cubit.dart` — the write path: toggles a session's bookmark via
  `ApiRepository` + `DBRepository.updateSession`, gated on being signed in
  (`HiveRepository.retrieveToken()`), and schedules a feedback-reminder notification on new bookmarks
  (see [notifications.md](notifications.md)).
- `ui/sessions_screen.dart` — the Sessions tab, with day-tab and schedule/compact view toggles
  (`ui/widgets/day_tab_view.dart`, `day_sessions_view.dart`, `schedule_view_card.dart`,
  `compact_view_card.dart`).
- `ui/session_details/session_details.dart` — detail page, reached via `/session-details` with a
  `LocalSession` passed as `state.extra`.

## `feed`

- `cubit/feed_cubit.dart` — cache-first fetch of feed entries (announcements/posts).
- `cubit/share_feed_post_cubit.dart` — wraps `ShareRepository` to share a feed post through the native
  share sheet.
- `ui/feed_screen.dart`, `widgets/share_sheet.dart`, `widgets/social_media_button.dart`.

## `feedback`

- `cubit/send_feedback_cubit.dart` — submits session feedback via `ApiRepository`
  (`FeedbackDto`/`feedback_dto.dart`).
- `ui/feedback_screen.dart` — reached via `/feedback`, optionally pre-filled with a `sessionSlug` passed
  as `state.extra`; this is also the deep-link target from the bookmark-reminder notification (see
  [notifications.md](notifications.md)).
- `widgets/` — `back_button.dart`, `emoji_container.dart` (feedback rating UI),
  `feedback_custom_appbar.dart`.

## `about`

- `cubit/fetch_individual_organisers_cubit.dart` — cache-first fetch of individual organiser profiles
  (as opposed to `home`'s organiser-team-level fetch — check `OrganiserType` usage before assuming
  these are the same data).
- `ui/about_screen.dart`, `ui/organising_team.dart`, `ui/organising_team_details.dart` — reached via
  `/organiser-details` for the detail page, with a `LocalIndividualOrganiser` passed as `state.extra`.

## `auth`

See [auth.md](auth.md) for the full flow. Cubits: `google_sign_in_cubit.dart`,
`social_auth_sign_in_cubit.dart`, `ghost_sign_in_cubit.dart`, `log_out_cubit.dart`. UI: `ui/sign_in.dart`
(also hosts the hidden reviewer-bypass long-press gesture, see [auth.md](auth.md)).
