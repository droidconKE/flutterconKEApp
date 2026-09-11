# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter packages get                                          # install dependencies
dart run build_runner build --delete-conflicting-outputs      # regenerate freezed/json_serializable/isar/hive_ce/injectable code (required after touching any model, repository, or DI annotation)
dart format --set-exit-if-changed lib test                    # format check (CI-enforced)
flutter analyze lib                                            # static analysis — CI treats ANY warning as fatal (exit 1), not just errors
flutter run --flavor development --target lib/main_development.dart   # run dev flavor
flutter run --flavor staging --target lib/main_staging.dart           # run staging flavor
flutter run --flavor production --target lib/main_production.dart     # run production flavor
flutter build apk --flavor <flavor> --target lib/main_<flavor>.dart   # build APK for a flavor
```

There is no `test/` directory with any test files yet — `flutter test` has nothing to run. CI (`pr-check.yml`) only gates on format + codegen + `flutter analyze`, run against PRs targeting `main` (not against `feat/*` branches directly — see Architecture below for why that matters).

`android/key.properties` is required locally to build (points at a shared public dev keystore for Firebase social-auth SHA1 matching) — see README.md "APK Signing" for the exact contents to create.

Gradle/AGP/Kotlin versions are pinned tightly together (`android/gradle/wrapper/gradle-wrapper.properties`, `android/settings.gradle`): AGP's minimum-supported Gradle version has been the recurring blocker when bumping either — check AGP's release notes for its Gradle floor before bumping one without the other.

## Architecture

### CI targets `main`, not the working branch

`.github/workflows/pr-check.yml`, `release-apk.yml`, and `release.yml` only trigger on `pull_request`/`release` events aimed at **`main`**. If active development happens on a long-lived branch (e.g. `feat/2026_rebrand`) with PRs stacked on top of *that* branch instead of `main`, none of those PRs get CI-checked — only the eventual PR from that branch into `main` does. When diagnosing "CI is failing," first confirm which PR the check actually ran on.

### Dependency injection: `injectable` + `get_it`, singletons only

`lib/core/di/injectable.dart` calls a generated `getIt.initGetIt()` (`@InjectableInit`). Every `@singleton`-annotated repository/service (`ApiRepository`, `AuthRepository`, `DBRepository`, `FirebaseRepository`, `HiveRepository`, `ShareRepository`, `NotificationService`, `FlutterConRouter`) is eagerly constructed with no injected constructor args — each wires its own dependencies internally. There are no `@injectable` (factory) registrations. **Cubits are not part of the DI graph at all** — they're constructed by hand in `lib/bootstrap.dart` (pulling repositories via `getIt()`) and provided app-wide through one large `MultiBlocProvider`. Adding a new Cubit means adding it to that list, not annotating it.

### Two local persistence stores with different jobs

- **Isar** (`isar_community`, `lib/common/repository/db_repository.dart`, models in `lib/common/data/models/local/*.dart`) is the queryable offline content cache: feed entries, speakers, sessions, sponsors, organisers. Used because it supports `.filter()` queries for search/browsing.
- **Hive** (`hive_ce`, `lib/common/repository/hive_repository.dart`, `lib/common/data/models/adapters.dart`) is the small key-value store: auth token, user profile, theme mode preference. Keyed to a per-flavor box name (`FlutterConValues.hiveBox`, e.g. `fluttercon-dev`).

Logout (`LogOutCubit`) wipes both: all Isar tables via `DBRepository.clearAllTables()`, and the token/profile/sessions keys via `HiveRepository.clearPrefs()`.

### Fetch pattern: cache-first, silent background refresh

Cubits that load list data (sessions, speakers, sponsors, organisers, feed) follow the same shape: if Isar already has data, emit `Loaded` from it immediately and kick off a network refresh in the background *without re-emitting* — the UI won't show newly-fetched data until the next explicit fetch. If Isar is empty (or `forceRefresh: true`), fetch from `ApiRepository` first, persist to `DBRepository`, then read back and emit. `SearchCubit` never touches the network — it's pure Isar filter queries. This means "data looks stale" bugs are usually about this silent-refresh path, not a caching bug per se.

### Routing has no auth guard

`lib/common/utils/router.dart` (go_router) declares routes but no `redirect:` logic. `lib/features/splash/splash_screen.dart` unconditionally navigates to the dashboard (its own comment notes auth-redirect was intentionally bypassed) — sign-in is reached manually, not enforced. Auth state lives in Hive and is only consulted by things that need a token (e.g. `NetworkUtil` attaching `Authorization: Bearer`, `BookmarkSessionCubit` gating on `HiveRepository.retrieveToken()`), not by routing.

The dashboard's bottom-nav (Home/Feed/Sessions/About) is a plain `PageView` inside `DashboardScreen`, not a go_router `ShellRoute` — tab switches don't change the URL/route stack.

### Flavors

Three entrypoints (`lib/main_development.dart`, `lib/main_staging.dart`, `lib/main_production.dart`) each construct a `FlutterConConfig` singleton (`lib/common/utils/env/flavor_config.dart`) with flavor-specific `baseDomain`, `hiveBox`, `eventSlug`, `organiserSlug` before calling `bootstrap()`. `NetworkUtil` reads the active config for its base URL. All three CI/release workflows only ever build the `production` flavor — `staging`/`development` are local-only.

### Networking accepts any TLS certificate

`lib/common/utils/network.dart`'s `badCertificateCallback` always returns `true`. Be aware of this if working on anything network-security-adjacent; it's an existing behavior, not something to silently "fix" as a drive-by in an unrelated change.
