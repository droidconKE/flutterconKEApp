# Authentication

*Last verified: 2026-09-11, against `feat/2026_rebrand`.*

Three ways in, one way out. All auth state (token + profile) lives in Hive, not Isar — see
[data-layer.md](data-layer.md).

## Google sign-in → app token exchange (two-step)

This is the normal user-facing path, and it's split across two Cubits deliberately chained in the UI,
not one:

1. **`GoogleSignInCubit.signInWithGoogle()`** (`lib/features/auth/cubit/google_sign_in_cubit.dart`) calls
   `AuthRepository.signInWithGoogle()` (`lib/common/repository/auth_repository.dart:29-73`), which uses
   `google_sign_in`'s `GoogleSignIn.instance` to authenticate, then Firebase `signInWithCredential` to
   validate. It asserts/throws if the resulting Firebase user is anonymous, and throws if no access
   token comes back. **It only returns a raw Google OAuth access token — it does not persist anything.**
2. The UI (`lib/features/auth/ui/sign_in.dart:22-34`) listens for that cubit's `loaded(token)` state and
   immediately calls **`SocialAuthSignInCubit.socialSignIn(token: token)`**
   (`lib/features/auth/cubit/social_auth_sign_in_cubit.dart`), which POSTs the token to the backend at
   `/social_login/google` (`AuthRepository.signIn`) to exchange it for the app's own `AuthResult
   {token, user}`, then persists both via `HiveRepository.persistToken()` / `persistUser()`
   (`social_auth_sign_in_cubit.dart:20-31`). Only this step's success navigates back to `decisionRoute`.

If you're debugging "sign-in succeeds but the user isn't actually logged in," check whether the second
step (`SocialAuthSignInCubit`) ran and succeeded — the first step alone persists nothing.

## Ghost/anonymous sign-in — reviewer bypass, not a general guest mode

`GhostSignInCubit.signIn()` calls `AuthRepository.ghostSignIn()`, which POSTs a hardcoded shared
credential (`email: 'google@play.com'`, `password: 'password'`) to `/login` — a de facto shared guest
backend account, same persistence path as above via Hive.

This is **not** exposed as a normal "continue as guest" button. It's gated behind a long-press gesture
on the sign-in screen's logo (`sign_in.dart:69-76`), and the gesture only fires the sign-in call if
*both*:
- `FirebaseRepository.getConfig().isInReview` is true (a Firebase Remote Config flag), **and**
- `config.appVersion == Misc.getAppVersion()` (the remote config's pinned version string matches the
  running app's version)

This exists so app-store reviewers can get into the app without real Google credentials, scoped to a
specific reviewed version — it's intentionally hidden and intentionally narrow. Don't repurpose it as a
general guest-login affordance without understanding this gating is load-bearing for review-bypass
security.

## Logout

`LogOutCubit.logOut()` (`lib/features/auth/cubit/log_out_cubit.dart`):
1. `DBRepository.clearAllTables()` — wipes all Isar collections
2. `AuthRepository.logOut()` — `GoogleSignIn.signOut()`
3. `HiveRepository.clearPrefs()` — deletes `accessToken`/`profile`/`sessions` keys

**Any exception during this sequence is swallowed** — the `catch` block still emits
`LogOutState.loaded()` (`log_out_cubit.dart:32-34`), so from the UI's perspective logout always
"succeeds" even if, say, Isar clearing throws. If a task involves surfacing logout failures, this is
the reason it currently can't.

## Where the token actually gets used

`NetworkUtil` (`lib/common/utils/network.dart`) reads `HiveRepository.retrieveToken()` on every request
to set `Authorization: Bearer <token>`. `BookmarkSessionCubit` separately checks
`HiveRepository.retrieveToken()` directly to decide whether bookmarking is allowed at all (see
[data-layer.md](data-layer.md)). There is no token refresh/expiry handling visible in this code — a
401 response is mapped to a `Failure` with message "Session timeout" (see
[networking-and-config.md](networking-and-config.md)) but nothing automatically re-authenticates or
clears the stale token on that response.
