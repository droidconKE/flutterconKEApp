import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

// Grayscale + ~1.25x contrast boost, applied before the blue duotone blend
// (see `_duotoneFilter`). Standard luminance-weighted grayscale, rescaled
// around the 0.5 midpoint for the contrast bump.
const _kContrast = 1.25;
const _kContrastOffset = (1 - _kContrast) / 2 * 255;

/// Speaker photo treatment from the web's `components/speakers/SpeakerCard.tsx`
/// (flutterconKE2024Web, `dev` branch): grayscale + contrast, screen-blended
/// over blue (CSS `mix-blend-screen` against a `bg-blue-600` backdrop), with a
/// faint repeating dot overlay. See docs/design/REBRAND-PLAN.md, Phase 3
/// (flutterconKEApp#260).
///
/// Renders unclipped — wrap in `ClipRRect`/`ClipOval` as the call site
/// already does for its own avatar shape.
class SpeakerDuotoneAvatar extends StatelessWidget {
  const SpeakerDuotoneAvatar({required this.imageUrl, super.key});

  final String imageUrl;

  // Grayscale+contrast followed by a screen blend with blue600, folded into
  // one matrix: screen(x, c) = x + c - x*c = x*(1 - c) + c per channel, which
  // is affine, so it composes with the matrix above. Applying it as the
  // image's own paint filter replaces two nested `ColorFiltered` widgets,
  // each of which rendered the avatar into its own offscreen layer.
  static final ColorFilter _duotoneFilter = ColorFilter.matrix(() {
    const c = AppColorRamps.blue600;
    List<double> row(double ch) {
      final k = 1 - ch;
      return [
        0.2126 * _kContrast * k,
        0.7152 * _kContrast * k,
        0.0722 * _kContrast * k,
        0,
        _kContrastOffset * k + ch * 255,
      ];
    }

    return <double>[...row(c.r), ...row(c.g), ...row(c.b), 0, 0, 0, 1, 0];
  }());

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorRamps.blue600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // Avatars are roughly square, so decoding at the box's longer
              // side keeps them sharp under BoxFit.cover.
              final decodeWidth = Misc.decodeSize(
                context,
                math.max(constraints.maxWidth, constraints.maxHeight),
              );
              return CachedNetworkImage(
                imageUrl: imageUrl,
                memCacheWidth: decodeWidth,
                // Same ResizeImage key as memCacheWidth, so it's decoded once.
                imageBuilder: (context, provider) => DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ResizeImage.resizeIfNeeded(
                        decodeWidth,
                        null,
                        provider,
                      ),
                      fit: BoxFit.cover,
                      colorFilter: _duotoneFilter,
                    ),
                  ),
                ),
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.error, color: Colors.red),
              );
            },
          ),
          IgnorePointer(child: CustomPaint(painter: _DotOverlayPainter())),
        ],
      ),
    );
  }
}

class _DotOverlayPainter extends CustomPainter {
  static const _spacing = 6.0;
  static const _dotRadius = 0.7;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..blendMode = BlendMode.overlay;

    // One path, one draw: `overlay` is an advanced blend that the renderer
    // has to emulate per draw call, so drawing each dot separately cost
    // hundreds of blend passes per avatar.
    final dots = Path();
    for (var y = _spacing / 2; y < size.height; y += _spacing) {
      for (var x = _spacing / 2; x < size.width; x += _spacing) {
        dots.addOval(Rect.fromCircle(center: Offset(x, y), radius: _dotRadius));
      }
    }
    canvas.drawPath(dots, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
