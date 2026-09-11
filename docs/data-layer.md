# Data Layer

*Last verified: 2026-09-11, against `feat/2026_rebrand`.*

## Two stores, two jobs

| | Isar (`isar_community`) | Hive (`hive_ce`) |
|---|---|---|
| File | `lib/common/repository/db_repository.dart` | `lib/common/repository/hive_repository.dart` |
| Holds | Feed entries, speakers, organisers, individual organisers, sponsors, sessions — the bulk queryable content cache | `accessToken`, `profile` (`FlutterConUser`), `themeMode` — small key-value prefs |
| Why | Supports `.filter()` queries (`titleContains`, `typeEqualTo`, etc.) for search/browsing offline | Simple, fast key-value access; no query needs |
| Opened in | `DBRepository.init()`, called from `bootstrap.dart`, result assigned to the global `Isar localDB` in `lib/core/di/injectable.dart` | `HiveRepository.initBoxes()`, opens one box named `FlutterConConfig.instance!.values.hiveBox` (per-flavor, e.g. `fluttercon-dev`) |
| Wiped on logout | `DBRepository.clearAllTables()` — clears *all* collections | `HiveRepository.clearPrefs()` — deletes only `accessToken`/`profile`/`sessions` keys (there's also an unused `clearBox()` that wipes everything) |

Both repositories are `@singleton` via injectable; `localDB` itself is a bare global, not fetched
through `getIt`.

## Isar collections

Defined in `lib/common/data/models/local/*.dart`, schemas generated into matching `.g.dart` files by
`isar_community_generator`:

- `LocalFeedEntry` — title, body, topic, url, createdAt, image
- `LocalSpeaker` — name, biography, avatar, tagline, twitter, facebook, linkedin, instagram, blog, companyWebsite
- `LocalOrganiser` — name, logo, tagline, type (`OrganiserType.name` string), bio, designation
- `LocalIndividualOrganiser` — same shape as `LocalOrganiser`, separate collection (searchable independently)
- `LocalSponsor` — name, logo, tagline, link, sponsorType, createdAt
- `LocalSession` — serverId (int, the API's session id — indexed via `serverIdEqualTo`), title, description,
  start/end time and datetime, slug, sessionCategory, sessionFormat, sessionLevel, isKeynote,
  isBookmarked, isServiceSession, sessionImage, plus embedded `EmbeddedSpeaker` list and `LocalRoom` list

Notable query behaviors worth knowing before changing this code:
- `fetchOrganisers(type)` explicitly excludes any organiser whose name contains `'Nairobi Gophers'`
  (`db_repository.dart:118-124`) — a hardcoded content filter, not a bug; don't "clean this up" without
  checking with whoever owns content curation.
- `searchSessions`/`searchSpeakers`/`searchIndividualOrganisers` all do case-insensitive substring
  matching across several fields OR'd together — this is what backs `SearchCubit`
  (`lib/features/home/cubit/search_cubit.dart`), which touches only Isar, never the network.
- `updateSession` looks up by `serverId`, not Isar's internal auto-increment id — always use the API's
  session id when updating a cached session (e.g. toggling a bookmark).
- `hasSessions()` is sync (`countSync()`), used by fetch cubits to decide cache-first vs network-first
  without an `await`.

## Hive keys

Exactly three keys are ever stored, all in the one per-flavor box:
`accessToken` (String), `profile` (`FlutterConUser`, custom `HiveType` via `FlutterConUserAdapter` in
`lib/common/data/models/adapters.dart`), `themeMode` (String — `ThemeMode.toString()`, parsed back with
`ThemeMode.values.firstWhere(..., orElse: () => ThemeMode.system)`).

## Remote models

`lib/common/data/models/*.dart` (excluding `local/`) — freezed classes with `json_serializable` for
`fromJson`/`toJson`: `Auth`/`AuthResult`, `Feed`, `FeedbackDto`, `Meta`, `Organiser`/`Organisers`,
`RemoteConfig`, `Room`, `SearchResult`, `Session`, `Speaker`, `Sponsor`. `Failure`
(`lib/common/data/models/failure.dart`) is hand-written, not freezed — it's the app's one error type,
thrown by `NetworkUtil`/`ApiRepository` and caught by name in cubits (see
[networking-and-config.md](networking-and-config.md)).

`lib/common/data/models/models.dart` is a barrel file re-exporting the above — prefer importing from it
rather than individual model files, matching existing usage.

## Repositories (all `@singleton`)

| Repository | Responsibility |
|---|---|
| `ApiRepository` | Thin wrapper over `NetworkUtil` per endpoint; methods `rethrow` on failure, no local caching logic itself |
| `AuthRepository` | Google sign-in (Firebase `signInWithCredential`), exchanging a Google token for the app's own token (`/social_login/google`), ghost/anonymous sign-in (`/login`), sign-out (`GoogleSignIn.signOut()`) — see [auth.md](auth.md) |
| `DBRepository` | All Isar reads/writes described above |
| `FirebaseRepository` | Firebase Remote Config init/fetch — backs feature flags like `isInReview` (see [auth.md](auth.md)) |
| `HiveRepository` | All Hive reads/writes described above |
| `ShareRepository` | Wraps native share sheet invocation (feed post sharing) |

## The cache-first fetch pattern

Every list-fetching cubit for content that's cached in Isar (sessions, speakers, sponsors, organisers,
feed) follows this shape — see e.g. `lib/features/sessions/cubit/fetch_grouped_sessions_cubit.dart`,
`lib/features/home/cubit/fetch_sessions_cubit.dart`, `lib/features/home/cubit/fetch_organisers_cubit.dart`,
`lib/features/feed/cubit/feed_cubit.dart`:

```
if (DBRepository has cached rows for this type AND !forceRefresh) {
  emit(Loaded(cachedRows))              // instant, from Isar
  _networkFetch()                        // fire-and-forget: ApiRepository -> DBRepository.persist*
                                          // result is NOT re-emitted; UI won't see it until next fetch
} else {
  await _networkFetch()                  // ApiRepository -> DBRepository.persist*
  emit(Loaded(await DBRepository.fetch*()))
}
```

Practical implications when working on these cubits:
- "The UI shows stale data after the network responds" is expected behavior on the cache-hit path, not
  a bug — the background refresh updates Isar for *next* load, it doesn't push to the current screen.
  If a task requires live-updating UI on refresh, that's a real behavior change, not a fix.
- A network failure during the background refresh (cache-hit path) can still surface as an error state
  even though valid cached data was already emitted, because the same try/catch wraps both the initial
  emit and the background call — check the specific cubit before assuming errors always mean "no data."
- `SearchCubit` and any Isar-only path never call `ApiRepository` — don't add network calls there without
  changing the documented contract.

`BookmarkSessionCubit` (`lib/features/sessions/cubit/bookmark_session_cubit.dart`) is the one significant
write path: gates on `HiveRepository.retrieveToken()` (must be signed in), calls
`ApiRepository.bookmarkSession(id)`, updates the cached row via `DBRepository.updateSession(...)`, and on
a new bookmark schedules a local notification via `NotificationService` (see
[notifications.md](notifications.md)).

## Code generation

Run via `dart run build_runner build --delete-conflicting-outputs` (required after touching any model,
repository annotation, or DI annotation):

| Generator | Produces |
|---|---|
| `freezed` | Sealed cubit state classes, remote model classes (`*.freezed.dart`) |
| `json_serializable` | `fromJson`/`toJson` for remote models (`*.g.dart`, same files as freezed for those classes) |
| `isar_community_generator` | Isar collection schemas for `local_*.dart` models (`local_*.g.dart`) |
| `hive_ce_generator` | `TypeAdapter`s for Hive types (`lib/common/data/models/adapters.dart` references generated adapters) |
| `injectable_generator` | `lib/core/di/injectable.config.dart` |
| `build_version` | `lib/versioning/build_version.dart`, configured via `build.yaml` |

`isar_community`'s version is pinned via a YAML anchor at the top of `pubspec.yaml`
(`isar_version: &isar_version 3.3.2`, reused by `isar_community`, `isar_community_flutter_libs`,
`isar_community_generator`) — keep all three in lockstep if bumping. A prerelease pin here once
transitively capped `analyzer` low enough to crash `build_runner` on newer Dart syntax; if `build_runner`
starts crashing with an analyzer visitor error after a Dart/Flutter SDK bump, check this pin first.
