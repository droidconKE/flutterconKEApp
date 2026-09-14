# FlutterconKE 2026 Rebrand — Flutter App Migration Plan

> Status: **Phase 0 done, Phase 1 next** · Last updated: 2026-09-11 · Tracking: [flutterconKEApp#243](https://github.com/droidconKE/flutterconKEApp/issues/243)

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
  throughout, no distinct display style) — see the font note below, this one has a real blocker
- No halftone/duotone image treatment (web's speaker-avatar duotone + dot overlay)
- No pill/rounded button language (web's `.btn-primary`/`.btn-outline`/`.btn-accent`)

## Font blocker — Rauschen B is licensed, same constraint as web

Rauschen B lives in the **private** `droidconKE/private-fonts` repo, fetched at build time and degrading
gracefully to a fallback (Montserrat) when unavailable — see that repo's description and the web's
`scripts/fetch-font.sh`. Porting the same mechanism to Flutter (fetch at CI/build time into a gitignored
asset, fall back to Montserrat otherwise) is its own decision with licensing and CI implications — **do
not bundle the font file into this public repo without explicit sign-off**. This is called out as its
own sub-issue (Phase 0b) so it doesn't block the rest of the token work, exactly like the web repo
treated it as a separately-blocked item (`#25` there) rather than gating Phase 0 on it. Until resolved,
display headlines should use Montserrat Black/ExtraBold uppercase as a visual stand-in — that's what
the web falls back to as well, so it stays consistent even unresolved.

## Phases

Each phase is its own GitHub sub-issue under #243 and its own branch off `feat/2026_rebrand`.

### Phase 0 — Design tokens (foundation) ✅

Full blue/magenta color ramps as Dart constants, a rounded-card radius scale, pill-badge/button style
constants, uppercase display text style (Montserrat stand-in until Phase 0b resolves), and the two
documented light/dark color-*inversion* pairs (About-style stat panel: black+magenta-figures in light ↔
magenta+white-figures in dark) as reusable theme extensions — not deferred to each screen to reinvent.
Foundation only; no screen restyling yet.

**Shipped** (flutterconKEApp#256):

- `lib/core/theme/theme_colors.dart` — `AppColorRamps` (blue50–900, magenta50–900)
- `lib/core/theme/theme_styles.dart` — `Corners` extended with the rebrand's rounded-card scale
  (s16/s24/s32/s40 + a `pill`/`pillBorder`/`pillRadius` trio)
- `lib/common/widgets/pill_badge.dart` — `PillBadge` widget (`level`/`format` variants)
- `lib/core/theme/button_styles.dart` — `AppButtonStyles.primary`/`.accent`/`.outline`
- `lib/core/theme/text_styles.dart` — `AppTextStyles.display` (Montserrat Black stand-in)
- `lib/core/theme/inverted_panel_theme.dart` — `InvertedPanelColors` `ThemeExtension`, registered on
  both `AppTheme.lightTheme()`/`darkTheme()` via `extensions:`

None of these are wired into any existing screen yet — registering the theme extension has no visual
effect until a screen reads it, and the button/badge/text-style builders are opt-in. Verified via
`flutter analyze` (clean) and a full debug APK build (succeeds).

### Phase 0b — Rauschen B font decision (parallel, non-blocking)

Decide and implement (or explicitly defer) the same private-repo-fetch-with-fallback pattern the web
uses. Needs a decision from whoever holds the font license/usage rights before implementation.

### Phase 1 — Global chrome

App bar, bottom nav, sign-in screen: confirm/finish logo match, apply Phase 0 tokens to button styles
already present (Google/ghost sign-in buttons), verify active-tab/active-link color usage is using the
new ramps where a single hex is currently hardcoded.

### Phase 2 — Home dashboard

Home tab restyle: hero-style header treatment, stat-card block (mirrors web's About 2×2 stats,
inverting between light/dark) if an "About"-style summary belongs on Home or the About screen — decide
placement to match how the web's `About.tsx` stats read (edition number, sessions delivered, attendees).

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
