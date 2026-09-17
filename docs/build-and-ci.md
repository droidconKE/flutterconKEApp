# Build, Flavors & CI

*Last verified: 2026-09-11, against `feat/2026_rebrand`.*

## Flavors

Three entrypoints, each setting up `FlutterConConfig` before calling `bootstrap()` (see
[networking-and-config.md](networking-and-config.md) for exactly what differs between them — mostly
just the Hive box name, not the API target):

```bash
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor staging      --target lib/main_staging.dart
flutter run --flavor production   --target lib/main_production.dart
flutter build apk --flavor <flavor> --target lib/main_<flavor>.dart
```

Android flavor config (app id suffix, `[DEV]`/etc. app name) lives in `android/app/build.gradle`.

## Local setup requirement: `android/key.properties`

Not committed (secrets). Required to build locally so social-auth SHA1 matches Firebase's registered
key — create it pointing at the shared public dev keystore:

```properties
storePassword=publicDevKey@2024
keyPassword=publicDevKey@2024
keyAlias=publicDevKey
storeFile=../public-dev-keystore.jks
```

(Exact contents/rationale in the root `README.md` "APK Signing" section — check there if this ever
changes, since it's the canonical source, not this file.)

## Code generation

`dart run build_runner build --delete-conflicting-outputs` — required after touching any
`@freezed`/`@JsonSerializable`/`@Collection` (isar)/`@HiveType`/`@singleton`/`@injectable`-annotated
class. See [data-layer.md](data-layer.md) for the full generator-to-output mapping. All three CI
workflows run this before `flutter analyze`.

## Android toolchain version coupling

`android/gradle/wrapper/gradle-wrapper.properties` (Gradle), `android/settings.gradle` (AGP and Kotlin
Gradle Plugin versions) are tightly coupled — each AGP release has a minimum-supported Gradle version,
and bumping one without checking the other's floor/ceiling is the most common way this project's Android
build breaks. When bumping any of the three, check AGP's release notes for its Gradle minimum first.

## GitHub Actions workflows (`.github/workflows/`)

**Important:** all three workflows below trigger only on events targeting **`main`**. If PRs are being
opened against a different long-lived branch (e.g. a `feat/*` branch under active development), *none*
of these run on those PRs — only the eventual PR from that branch into `main` gets checked. Always
confirm which PR's base branch a CI result actually belongs to before concluding "CI is broken" or
"CI is passing."

| Workflow | Trigger | What it does |
|---|---|---|
| `pr-check.yml` ("Check Pull Request") | `pull_request` → `main` | `flutter packages get` → `dart format --set-exit-if-changed lib test` → build_runner → `flutter analyze lib`. Pure lint/format/analyze gate; **`flutter analyze` fails the job on any warning, not just errors** — see [CLAUDE.md](../CLAUDE.md). No build artifact produced. |
| `release-apk.yml` ("Generate Production APK") | `pull_request` → `main` (a `push: branches: [main]` trigger exists in the file but is commented out) | Same format/codegen/analyze steps, then decodes `secrets.PROD_KEYSTORE` into `key.jks`, writes `android/key.properties` from secrets (`PROD_KEYSTORE_PASSPHRASE`/`PROD_KEYSTORE_PASSWORD`/`PROD_KEYSTORE_ALIAS`), builds `flutter build apk --flavor production --target lib/main_production.dart`, uploads `app-production-release.apk` as a workflow artifact. Effectively "build a signed prod APK on every PR for manual testing." |
| `release.yml` ("Generate Production AAB") | `release: types: [published]` (only when a GitHub Release is published) | Same format/codegen/analyze + keystore setup, builds `flutter build appbundle --flavor production`, then sets up Ruby/bundler and runs `bundle exec fastlane supply --aab ... --track production` using `ANDROID_PACKAGE_NAME`/`PLAY_STORE_CREDENTIALS` secrets. **This is the actual Play Store production deploy pipeline** — it only runs when someone publishes a GitHub Release. |

All three only ever build/deploy the **`production`** flavor — there is no CI workflow that builds
`staging` or `development`. All three use `subosito/flutter-action@v2` with `flutter-version: 3`
(latest 3.x, not pinned to an exact version) — CI's Flutter version can drift ahead of what's pinned
for local dev in `android/local.properties`/whatever SDK a contributor has installed; if a build passes
locally but fails in CI (or vice versa) on something codegen-related, check for a Flutter/Dart version
mismatch first.
