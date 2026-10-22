# FlutterconKE 2026 Rebrand — Flutter App Migration Plan

> Status: **All phases (0, 0b, 1, 2, 3, 4, 5) done — migration complete** · Last updated: 2026-10-12 · Tracking: [flutterconKEApp#243](https://github.com/droidconKE/flutterconKEApp/issues/243)

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

### Phase 3 — Sessions & Speakers ✅

The highest-value phase — directly portable from web PR #32. Session cards (`schedule_view_card.dart`,
`compact_view_card.dart`, `day_sessions_view.dart`) get the rounded-card treatment, time-badge box, and
level/format pill badges matching `SessionListCard.tsx`'s pattern exactly (same badge colors: magenta
pill for level, blue pill for format). Speaker cards/grid tiles get the duotone/halftone avatar
treatment from `SpeakerCard.tsx` (grayscale + contrast + blue duotone + dot overlay — achievable with
`ColorFiltered` + a custom dot-pattern `Painter`/asset overlay in Flutter).

**Shipped** (flutterconKEApp#260):

- **`SessionTimeBadge`** (`lib/features/sessions/ui/widgets/session_time_badge.dart`) — the rounded
  time-badge box (time + AM/PM stacked), reused by both session card variants.
- **`CompactViewCard`** rebuilt from a `ListTile` to a custom layout matching `SessionListCard.tsx`:
  rounded-4xl bordered card, `SessionTimeBadge`, level/format `PillBadge`s (skipped for service
  sessions, matching the web's `!is_serviceSession` check), speaker names in primary color.
- **`ScheduleViewCard`**: same rounded-4xl border + `SessionTimeBadge` + pill badges added alongside its
  existing image banner and speaker-avatar row (kept — the web has no direct equivalent of this
  image-forward variant, so it keeps its own richer layout rather than being forced into
  `SessionListCard.tsx`'s shape).
- **`SpeakerDuotoneAvatar`** (`lib/features/home/widgets/speaker_duotone_avatar.dart`) — grayscale +
  contrast `ColorFiltered`, then a second `ColorFiltered` with `BlendMode.screen` against blue (the
  Flutter equivalent of the web's `mix-blend-screen` over a `bg-blue-600` backdrop), plus a
  `CustomPainter` dot overlay. Wired into `SpeakerGridTile` (speakers grid/list) and
  `SpeakerDetailsPage` (detail header) — **not** into the shared `PersonnelWidget`, since that widget is
  also used for organisers on the About screen, which don't get this speaker-specific treatment on the
  web either.
- `SpeakerGridTile` also picked up the rounded-4xl bordered card shape to match session cards.

**Verification note**: the session-card redesign (compact + schedule views, both light and dark mode)
was confirmed visually on an emulator — rounded borders, time badges, and pill badges all render as
intended. The speaker duotone avatar was verified by code review and a clean `flutter analyze`/build
only, not a fresh on-device screenshot — the emulator's touch-input injection stopped registering taps
partway through this phase's verification (swipes still worked; likely an emulator-session quirk, not
an app issue) and recovery attempts (adb restart, alternate input sources) didn't resolve it. Worth a
manual look on a real device/fresh emulator before considering this phase fully visually confirmed.

### Phase 4 — Sponsors, Feed, Feedback, About ✅

Apply Phase 0 tokens/components consistently across the remaining screens. Sponsors tiering visuals,
feed post cards, feedback emoji/rating UI, about/organiser cards all get the rounded-card + pill/button
language so nothing looks pre-rebrand next to Sessions/Speakers.

**Shipped** (flutterconKEApp#261):

- **`SponsorsCard`/`OrganizersCard`** (`lib/features/home/widgets/`): outer card radius bumped to
  `Corners.s24Border`, inner logo tiles to `Corners.s16Border`, and the border changed from
  dark-mode-only (`transparent` in light, `colorScheme.primary` in dark) to always-on — matching every
  other rebrand card, which borders in both themes rather than treating it as a dark-mode-only accent.
  Added missing item spacing to `SponsorsCard`'s horizontal tile list (it previously relied on the
  light-mode border being invisible to hide the lack of a gap; with an always-on border that would have
  made adjacent tiles look fused).
- **`feed_screen.dart`**: each post wrapped in a `Corners.s32Border`-bordered card (replacing a bare
  divider-separated list), feed images switched from a `Container` with a `borderRadius` that was
  never actually clipping its child (`BoxDecoration.borderRadius` doesn't clip content — a pre-existing
  no-op, not something this phase introduced) to a proper `ClipRRect` with `Corners.s16Border`.
- **`feedback_screen.dart`**: submit button now uses Phase 0's `AppButtonStyles.primary(context)`
  instead of a hand-rolled `ElevatedButton.styleFrom`. Also fixed its label color, which was set to
  `colorScheme.surface` — near-black in dark mode, i.e. dark text on the blue button background, a
  pre-existing low-contrast bug — to a plain white matching the button style's foreground.
- **`EmojiContainer`** (feedback rating tiles): radius bumped to `Corners.s16Border` to match the rest
  of the card scale.
- **About/organiser cards**: no change needed beyond what Phase 3 already decided —
  `organising_team.dart`'s grid uses the shared `PersonnelWidget` (deliberately not given the
  speaker-only duotone treatment, see Phase 3), and `organising_team_details.dart` has no card chrome
  to restyle, matching `speaker_details.dart`'s equally chrome-less layout.

**Verification**: `SponsorsCard`/`OrganizersCard` confirmed visually on an emulator in both light and
dark mode — rounded borders, always-on border color, and tile spacing all render as intended. The feed
card restyle could **not** be visually confirmed — the test event's feed endpoint returned no data
("Not found") on the build used for this pass, unrelated to this phase's changes. The feedback button
swap was verified by code review and clean analyze/build only, not re-screenshotted, since it reuses
the already-proven `AppButtonStyles.primary`.

### Phase 5 — Polish ✅

Dark-mode QA against both documented inversion cases, accessibility pass (contrast on the new ramps),
responsive check across phone sizes, remove any now-unused pre-rebrand color constants/assets, and
update this doc + the AI-agent `docs/` (see [docs/README.md](../README.md)) to reflect the final state.

**Shipped** (flutterconKEApp#262):

- **Accessibility pass — contrast computed for every new color pairing** (WCAG relative-luminance
  formula, not eyeballed):
  - **Fixed**: `PillBadge`'s format variant and `SessionTimeBadge`'s light-mode text were
    `flutterconBlue` (blue700) on `blue50` — 3.2:1, below the 4.5:1 AA threshold for this text size.
    Both are internal component choices (not literal copies of a specific shipped web class value for
    *this* exact pairing), so swapped to `blue800` from the same ramp — 5.1:1, passes AA, and reads as
    visually identical at a glance.
  - **Found, not changed — inherited from the shared design system, shipped identically on web**:
    - `AppButtonStyles.primary` (white text on `flutterconBlue`): 3.4:1. This is a direct, intentional
      copy of the web's `.btn-primary` (`text-white bg-primary`) — already live on the public site with
      the same ratio. Changing it only in the Flutter app would make the two surfaces diverge, which is
      the opposite of this migration's goal.
    - `InvertedPanelColors.dark` (white figures on the magenta panel): 3.1:1. This is the explicit,
      documented color-inversion design decision from the web (see "What's already aligned" above) —
      also not something to override unilaterally.
    - The magenta bottom-nav-selected-item color on a white light-mode background: 3.1:1. Pre-existing,
      predates this rebrand entirely (same `flutterconMagenta` value used for selected state before
      Phase 0 started).

    All three are AA-compliant for *large* text (≥3:1) but not small/normal text at 4.5:1. Worth a
    conversation with whoever owns the Figma export if the team wants the brand ramp itself adjusted —
    that would fix web and app together, which a Flutter-only patch can't.
- **Dark-mode QA**: re-confirmed visually across every phase's deliverable this session covered —
  session cards (Phase 3), sponsors/organisers cards (Phase 4) — matching their light-mode counterparts
  correctly, and the one documented inversion case (About stats panel, Phase 2) swaps correctly in both
  directions.
- **Responsive check**: reasoned through `AboutStatsPanel`'s fixed `childAspectRatio` grid (the
  component most likely to be fragile on a narrow phone, since everything else in this rebrand uses
  `Wrap`/`Expanded`/`AutoSizeText` which reflow safely) against a 320dp-wide device budget — content
  height clears the available cell height with margin to spare even with the longest label ("ATTENDEES
  SINCE 2018") wrapping to two lines. Not re-verified on an actual small-width emulator this round.
- **Cleanup**: removed `ThemeColors.greyDarkThemeBackground` (zero usages anywhere) and
  `assets/images/flutterconke_logo.png` (the pre-rebrand logo bitmap, unreferenced by any Dart code or
  config since the Flutter-blue SVG mark replaced it — confirmed by checking every asset-referencing
  config file, not just `lib/`). Left the unrelated pre-existing unused `Corners` scale entries
  (`s3`/`s5`/`s8`/`dialog`/`btn` and their `Border`/`Radius` variants) alone — they predate this rebrand
  entirely and aren't "now-unused because of" anything this migration did.
- **Docs**: checked `docs/architecture.md` and `docs/data-layer.md` (the AI-agent docs that mention
  theming) against the current code — both still accurate, no updates needed.

This closes out the 2026 flutterconKE rebrand migration (#243) — all six phases (0, 0b, 1, 2, 3, 4, 5)
shipped.

## Notes for whoever picks up a phase

- The web repo is the layout/pattern reference, not a literal 1:1 spec — mobile navigation, card density,
  and touch targets differ from a desktop/responsive web layout. Match the *visual language* (colors,
  radii, pill badges, duotone treatment, typography weight/case), not literal pixel measurements.
- Cross-check hex values against `tailwind.config.js` on the web repo's `dev` branch if this doc ever
  goes stale — that file is the source of truth for the ramps, this doc just mirrors it at time of
  writing.
- Keep phases small enough to review; the web side did the same (many small PRs into one integration
  branch, squashed into `dev` once approved) rather than one giant redesign PR.
