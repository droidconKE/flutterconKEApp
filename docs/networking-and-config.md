# Networking & Configuration

*Last verified: 2026-09-11, against `feat/2026_rebrand`.*

## Flavor configuration

`FlutterConConfig` (`lib/common/utils/env/flavor_config.dart`) is a manual singleton (factory
constructor returning a cached `_instance`) holding a `FlutterConValues` record set once by whichever
`main_<flavor>.dart` runs first. All three flavors currently point at the **same** API domain:

| Flavor | `baseDomain` | `hiveBox` | `eventSlug` | `organiserSlug` |
|---|---|---|---|---|
| development | `api.droidcon.co.ke` | `fluttercon-dev` | `flutterconke-2025-171` | `flutterconke-571` |
| staging | `api.droidcon.co.ke` | `fluttercon-stg` | `flutterconke-2025-171` | `flutterconke-571` |
| production | `api.droidcon.co.ke` | `fluttercon-prod` | `flutterconke-2025-171` | `flutterconke-571` |

In other words, **there is no separate staging/dev backend today** — flavors only isolate the local Hive
box (so signing in as dev doesn't clobber prod's cached token) and the app id suffix
(`android/app/build.gradle`), not the API target. Don't assume `development`/`staging` are safe to hit
destructively differently from `production` — they hit the real API.

`eventSlug`/`organiserSlug` are baked into API paths (`/events/$eventSlug/...`) — this app is
effectively hardwired to one droidcon/FlutterCon event per build; supporting multiple events would need
these to become runtime-configurable rather than compile-time constants.

## `NetworkUtil` (`lib/common/utils/network.dart`)

Manually-implemented singleton (factory constructor pattern, not `@singleton`/injectable) wrapping
`dio`. `_getHttpClient()` builds a **fresh `Dio` instance per request** with:
- `baseUrl`: `'${FlutterConConfig.instance!.values.baseUrl}/v1'`
- Static header `Api-Authorization-Key: droidconKe-2020`
- Request interceptor injecting `Authorization: Bearer <token>` from
  `getIt<HiveRepository>().retrieveToken()` (empty string if not signed in)
- `PrettyDioLogger` only in `kDebugMode`
- `badCertificateCallback` that **always returns `true`** — accepts any TLS certificate, including
  invalid/expired/self-signed ones. This is a real security-relevant detail, not something to casually
  "fix" as a drive-by in an unrelated change — but do flag it if a task's scope includes network security.
- `connectTimeout`/`receiveTimeout` are both set to `Duration(seconds: 60 * 1000)` — that's **60,000
  seconds (~16.7 hours)**, not 60 seconds. This looks like a units mistake (probably meant
  `Duration(milliseconds: 60 * 1000)`), meaning requests effectively never time out client-side on a
  hung connection. Note there's also an unused `ApiConstants` class
  (`lib/common/utils/constants/api_constants.dart`) with a correct 15-second timeout and generic
  endpoint constants (`/users`, `/posts`, etc.) that don't match any real endpoint here — it appears to
  be leftover boilerplate from a template and is not wired into `NetworkUtil`.

Four request methods, all with the same try/catch shape: `getReq`, `postReq`, `putReq`,
`postWithFormData` (multipart, used for endpoints needing file upload alongside form fields). Error
mapping is consistent across all four:

| Condition | Result |
|---|---|
| Response body is an empty map | `Failure('An error occured, please try again later')` |
| `SocketException` | `Failure('No internet connection')` |
| `TimeoutException` | `Failure('Session timeout')` |
| `DioException`, status 401 | `Failure('Session timeout', statusCode: 401)` |
| `DioException`, status 404 | `Failure('Not found', statusCode: 404)` |
| `DioException`, status 422 (POST/PUT/form only) | `Failure(response.data['message'], statusCode: 422)` |
| `DioException`, status 500 | `Failure(response.data['message'], statusCode: 500)` |
| `DioException`, type `unknown` | bare `Exception('Server error')` (not a `Failure`) |
| `DioException`, type `connectionTimeout`/`connectionError` | rethrown as `SocketException` |
| anything else | bare `Exception('Server error')` |

Because some paths throw `Failure` and others throw a bare `Exception`/`SocketException`, callers that
only `catch (e) on Failure` and fall back to a generic message for everything else (the pattern used
throughout the cubits) will show a generic error for those non-`Failure` cases — this is intentional
enough to be the existing contract, but worth knowing when writing a new cubit: catch `Failure`
specifically for a precise message, and a general `catch` for everything else, matching existing cubits.

There is no 401-triggered auto-logout or token clear anywhere — a expired/invalid token just keeps
producing "Session timeout" failures until the user manually logs out and back in.

## `ApiRepository` endpoints (`lib/common/repository/api_repository.dart`)

Each method is a thin wrapper: build the path (using `_eventSlug`/`_organiserSlug` where relevant), call
`NetworkUtil`, parse the typed response, `rethrow` on any error (no local error transformation at this
layer — that all happens in `NetworkUtil`).

| Method | Endpoint |
|---|---|
| `fetchSpeakers({perPage, page})` | `GET /events/$eventSlug/speakers` |
| `fetchRooms()` | `GET /events/$eventSlug/rooms` |
| `fetchSessions({perPage, page})` | `GET /events/$eventSlug/sessions` (check file for exact path if adding pagination logic) |
| `fetchFeeds({perPage, page})` | `GET /events/$eventSlug/...` feed endpoint |
| `fetchOrganisers(...)` | organiser-team endpoint, parameterized by organiser type |
| `fetchSponsors({perPage, page})` | `GET /events/$eventSlug/sponsors` |
| `bookmarkSession(sessionId)` | write endpoint toggling a session bookmark |
| `submitFeedback({feedbackDTO})` | feedback submission endpoint |

(Full request bodies/exact paths are in the file itself — this table is for locating the right method
quickly, not a substitute for reading it before changing request shapes.)

The full REST API is also documented externally via Postman — link in the root `README.md`.
