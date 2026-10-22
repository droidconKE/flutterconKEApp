import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Display typography introduced by the 2026 rebrand. The web uses a
/// licensed heavy-grotesque display font (Rauschen B), fetched at build
/// time from a private repo and served from droidcon's own web
/// infrastructure — the license explicitly covers that use.
///
/// This app deliberately does **not** do the same: the license grants
/// serving a web font from our own infrastructure, but a compiled mobile
/// app instead bundles the font file inside every installed APK/IPA —
/// trivially extractable by unzipping — which is a materially different
/// distribution than serving over HTTPS from a server we control, and
/// isn't something the license text actually covers. See
/// flutterconKEApp#257 and docs/design/REBRAND-PLAN.md for the full
/// reasoning. [display] uses Montserrat Black as the permanent choice, not
/// a placeholder pending a future decision — the same font family already
/// used for this app's body text, so the display style reads as a weight/
/// case variation of the existing type rather than a mismatched one-off.
class AppTextStyles {
  AppTextStyles._();

  /// Large uppercase display headline (e.g. a hero/section title). Caller
  /// is responsible for uppercasing the label string — this only sets the
  /// weight/spacing, matching the web's `.title`/`font-display` treatment.
  static TextStyle display({double fontSize = 32, Color? color}) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 0.5,
      height: 1,
      color: color,
    );
  }
}
