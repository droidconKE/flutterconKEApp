# FlutterconKE 2026 Rebrand — Flutter App Migration Plan

> Status: **Phases 0, 0b, 1, 2 done, Phase 3 next** · Last updated: 2026-09-17 · Tracking: [flutterconKEApp#243](https://github.com/droidconKE/flutterconKEApp/issues/243)

This plan ports the flutterconKE web rebrand to the Flutter app so both surfaces read as one brand.
It is deliberately modeled on the web repo's own plan
([`flutterconKE2024Web` docs/design/REDESIGN-PLAN.md](https://github.com/droidconKE/flutterconKE2024Web/blob/dev/docs/design/REDESIGN-PLAN.md))
— same phase shape, adapted for mobile instead of web chrome. Read that doc first if you need the
*design rationale* (color decisions, why things invert between themes, etc.); this doc is about the
Flutter-side execution.

All work merges into **`feat/2026_rebrand`**, one phase per PR (or more, if a phase is large), each
tracked by its own sub-issue under [#243](https://github.com/droidconKE/flutterconKEApp/issues/243).

## Source of truth

- Web redesign issue: [flutterconKE2024Web#23](https://github.com/droidconKE/flutterconKE2024Web/issues/23)
- Web redesign plan: `docs/design/REDESIGN-PLAN.md` on the web repo's `dev` branch
- Web PRs that actually built it (chronological): #24 (plan+assets), #26 (font injection), #27 (design
  tokens), #29 (phase 2 homepage), #30 (remove auth), #31 (polish+propagate), #32 (**sessions, speakers,
  session detail, about & sponsors redesign** — the most directly portable one, since those are shared
  screens with this app), #34–#40 (navbar/footer fixes, revised landing page, about/sponsors pages)
- This app's tracking issue: [flutterconKEApp#243](https://github.com/droidconKE/flutterconKEApp/issues/243)

## What's already aligned (verified 2026-09-11)

The Flutter app isn't starting from zero — some of the rebrand already landed incidentally:

- **Primary/accent colors already match exactly**: `ThemeColors.flutterconBlue` (`#008BFF`) and
  `flutterconMagenta` (`#F73EDE`) in `lib/core/theme/theme_colors.dart` are the same hex values as the
  web's `primary`/`accent` tokens.
- **The app-bar/sign-in logo asset was already swapped** (`assets/images/flutterconlogo_light.svg`
  /`_dark.svg`, commit `741750e`) to the Flutter-blue mark — worth a pixel-diff against the web's
  `public/images/new-design/logo-light.svg`/`logo-dark.svg` in Phase 1, but likely just needs
  confirmation, not a rebuild.
- **Bottom nav already uses the new accent colors** (`lib/common/widgets/bottom_nav/bottom_nav_bar.dart`
  — magenta selected item, blue active icon).

What's *not* aligned yet — this is the actual scope of the migration:

- No full color **ramps** (web has `blue-50`..`blue-900`, `magenta-50`..`magenta-900`; the app only has
  the two headline hex constants)
- No rounded-card system (web: `rounded-3xl`/`rounded-4xl` = 1.5–2rem; app: default `Card` shapes, small
  ad-hoc radii like `Corners.s12Border`)
- No pill-badge language (web's session-level/format chips, `rounded-full` colored pills)
- No stat-card / color-inverting panel pattern (web's About section 2×2 stats block)
- No display typography treatment (web: **Rauschen B**, heavy grotesque, uppercase; app: Montserrat
  throughout) — resolved as **won't-port**, see the font note below; Montserrat Black is the permanent
  display choice for this app, not a placeholder
- No halftone/duotone image treatment (web's speaker-avatar duotone + dot overlay)
- No pill/rounded button language (web's `.btn-primary`/`.btn-outline`/`.btn-accent`)

## Font decision — Rauschen B: won't-port (flutterconKEApp#257, decided 2026-09-16)

Rauschen B lives in the **private** `droidconKE/private-fonts` repo. Its README states the license
terms explicitly: it permits **serving a web font from our own infrastructure**, and explicitly
forbids committing the file to a public repo or sharing it externally. The web sites fetch it at build
time into a gitignored path and serve it via `@font-face`, degrading gracefully to Montserrat when the
fetch has no credentials (e.g. an external contributor) — see that repo's README and the web's
`scripts/fetch-font.sh`.

That license grant doesn't extend to this app. A compiled mobile app bundles the font file directly
inside every installed APK/IPA — trivially extractable by unzipping the app package — which is a
materially different distribution model than serving a file over HTTPS from a server droidcon
controls. The license text covers the latter; it says nothing about the former, and reads as scoped to
web-serving specifically (it separately calls out that even the `.otf` variant already in that repo
must never be used "for web embedding," i.e. the license is granular about *how* the font may be
served — nothing in it addresses app-binary embedding at all).

**Decision: do not port this.** Montserrat Black (already shipped in Phase 0's `AppTextStyles.display`)
is the **permanent** display font for this app, not a stand-in pending a future resolution. Revisit only
if whoever holds the Rauschen B license/usage rights explicitly confirms app-binary embedding is
covered — that would need to come from Out of the Dark (the font's creator) or droidcon's brand team,
not be inferred from the web's existing (web-scoped) grant.

## Phases

Each phase is its own GitHub sub-issue under #243 and its own branch off `feat/2026_rebrand`.

### Phase 0 — Design tokens (foundation) ✅

Full blue/magenta color ramps as Dart constants, a rounded-card radius scale, pill-badge/button style
constants, uppercase display text style (Montserrat Black — see the font decision below), and the two
documented light/dark color-*inversion* pairs (About-style stat panel: black+magenta-figures in light ↔
magenta+white-figures in dark) as reusable theme extensions — not deferred to each screen to reinvent.
Foundation only; no screen restyling yet.

**Shipped** (flutterconKEApp#256):

- `lib/core/theme/theme_colors.dart` — `AppColorRamps` (blue50–900, magenta50–900)
- `lib/core/theme/theme_styles.dart` — `Corners` extended with the rebrand's rounded-card scale
  (s16/s24/s32/s40 + a `pill`/`pillBorder`/`pillRadius` trio)
- `lib/common/widgets/pill_badge.dart` — `PillBadge` widget (`level`/`format` variants)
- `lib/core/theme/button_styles.dart` — `AppButtonStyles.primary`/`.accent`/`.outline`
- `lib/core/theme/text_styles.dart` — `AppTextStyles.display` (Montserrat Black — now the permanent
  display choice, see Phase 0b below)
- `lib/core/theme/inverted_panel_theme.dart` — `InvertedPanelColors` `ThemeExtension`, registered on
  both `AppTheme.lightTheme()`/`darkTheme()` via `extensions:`

None of these are wired into any existing screen yet — registering the theme extension has no visual
effect until a screen reads it, and the button/badge/text-style builders are opt-in. Verified via
`flutter analyze` (clean) and a full debug APK build (succeeds).

### Phase 0b — Rauschen B font decision (parallel, non-blocking) ✅ won't-port

**Decided 2026-09-16: not porting.** See "Font decision" above for the full reasoning — the license
covers serving a web font from droidcon's own infrastructure, not bundling the file inside a
distributed app binary, and that gap isn't something to resolve by inference. Montserrat Black
(`AppTextStyles.display`, shipped in Phase 0) is the permanent display font for this app.

### Phase 1 — Global chrome ✅

App bar, bottom nav, sign-in screen: confirm/finish logo match, apply Phase 0 tokens to button styles
already present (Google/ghost sign-in buttons), verify active-tab/active-link color usage is using the
new ramps where a single hex is currently hardcoded.

**Findings** (flutterconKEApp#258):

- **Logo already matches exactly** — rendered both `assets/images/flutterconlogo_light.svg`/`_dark.svg`
  and the web's `public/images/new-design/logo-light.svg`/`logo-dark.svg` to PNG and compared pixel-for-
  pixel: identical mark, identical colors, both light and dark variants. No asset change needed.
- **No stray pre-rebrand colors found** — grepped for raw hex `Color(0xff...)` outside the theme files
  and for legacy `Colors.blue`/`.amber`/etc.: none. Every color reference already goes through
  `ThemeColors`.
  - `sign_in.dart`'s only visible button is `GoogleAuthButton` (the `auth_buttons` package) — a
    third-party Google-branded button that **should not** be restyled with the rebrand's pill language;
    Google's own brand guidelines govern that button's shape. The ghost sign-in path is a hidden
    long-press gesture on the logo, not a visible button. So there was no real "apply pill styles to
    sign-in buttons" work available on that screen specifically.
- **Applied the pill language where a real opportunity existed**: `FeedbackButton`
  (`lib/common/widgets/app_bar/feedback_button.dart`, visible in the app bar on most screens) now uses
  `Corners.pillBorder` instead of a fixed 10px radius; the logout confirmation dialog
  (`lib/common/widgets/app_bar/logout_dialog.dart`) now uses `Corners.pillBorder` on its destructive
  "confirm" button (kept red — destructive-action semantics, not a rebrand color) and
  `AppButtonStyles.outline` on its "cancel" button.
- **Deliberately left alone**: `session_filter.dart`'s `SegmentedButton`/filter-panel buttons — that's
  session-filtering UI, not global chrome, and belongs with Phase 3's more thorough Sessions pass rather
  than a piecemeal touch here.

### Phase 2 — Home dashboard ✅

Home tab restyle: hero-style header treatment, stat-card block (mirrors web's About 2×2 stats,
inverting between light/dark) if an "About"-style summary belongs on Home or the About screen — decide
placement to match how the web's `About.tsx` stats read (edition number, sessions delivered, attendees).

**Shipped** (flutterconKEApp#259):

- **Placement: the About screen, not Home.** `about_screen.dart` already had an "About" headline +
  description paragraph structurally identical to the web's About section intro — the stat block reads
  as a natural continuation of that content, not a dashboard-summary fit for Home. Left Home's "hero-
  style header treatment" out of scope here — that's a separate, larger visual question (the web's Hero
  is Phase 2 there but a distinct component from the stats block) better handled with its own decision
  if/when it comes up, rather than folded into this stat-panel port.
- **`AboutStatsPanel`** (`lib/features/about/widgets/about_stats_panel.dart`) — the 2×2 grid with the
  same four values/labels as the web's `About.tsx` (3RD Fluttercon edition, 7th Droidcon edition, 230+
  sessions delivered, 3,000+ attendees since 2018), using Phase 0's `InvertedPanelColors` extension and
  `AppTextStyles.display` for the figures. Wired into `about_screen.dart` right after the existing intro
  text, before "Organising Team".
- **Verified visually**, not just via analyze/build — ran the app on an emulator, navigated to the About
  screen, and confirmed both color-inversion states directly: black panel + magenta figures in light
  mode, magenta panel + white figures in dark mode (toggled via `adb shell cmd uimode night yes/no`),
  matching the web's design exactly.

### Phase 3 — Sessions & Speakers

The highest-value phase — directly portable from web PR #32. Session cards (`schedule_view_card.dart`,
`compact_view_card.dart`, `day_sessions_view.dart`) get the rounded-card treatment, time-badge box, and
level/format pill badges matching `SessionListCard.tsx`'s pattern exactly (same badge colors: magenta
pill for level, blue pill for format). Speaker cards/grid tiles get the duotone/halftone avatar
treatment from `SpeakerCard.tsx` (grayscale + contrast + blue duotone + dot overlay — achievable with
`ColorFiltered` + a custom dot-pattern `Painter`/asset overlay in Flutter).

### Phase 4 — Sponsors, Feed, Feedback, About

Apply Phase 0 tokens/components consistently across the remaining screens. Sponsors tiering visuals,
feed post cards, feedback emoji/rating UI, about/organiser cards all get the rounded-card + pill/button
language so nothing looks pre-rebrand next to Sessions/Speakers.

### Phase 5 — Polish

Dark-mode QA against both documented inversion cases, accessibility pass (contrast on the new ramps),
responsive check across phone sizes, remove any now-unused pre-rebrand color constants/assets, and
update this doc + the AI-agent `docs/` (see [docs/README.md](../README.md)) to reflect the final state.

## Notes for whoever picks up a phase

- The web repo is the layout/pattern reference, not a literal 1:1 spec — mobile navigation, card density,
  and touch targets differ from a desktop/responsive web layout. Match the *visual language* (colors,
  radii, pill badges, duotone treatment, typography weight/case), not literal pixel measurements.
- Cross-check hex values against `tailwind.config.js` on the web repo's `dev` branch if this doc ever
  goes stale — that file is the source of truth for the ramps, this doc just mirrors it at time of
  writing.
- Keep phases small enough to review; the web side did the same (many small PRs into one integration
  branch, squashed into `dev` once approved) rather than one giant redesign PR.
