import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Display typography introduced by the 2026 rebrand. The web uses a
/// licensed heavy-grotesque display font (Rauschen B); porting that same
/// font to this app is a separate, licensing-gated decision — see
/// flutterconKEApp#257 and docs/design/REBRAND-PLAN.md.
///
/// Until #257 resolves, [display] uses Montserrat Black as a visual
/// stand-in — the same font family already used for this app's body text
/// (and the same fallback the web itself uses when the licensed font isn't
/// fetched at build time), so nothing regresses either way #257 is decided.
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
