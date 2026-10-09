import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

// Grayscale + ~1.25x contrast boost, applied before the blue duotone blend
// below. Standard luminance-weighted grayscale row repeated across R/G/B,
// then rescaled around the 0.5 midpoint for the contrast bump.
const _kContrast = 1.25;
const _kContrastOffset = (1 - _kContrast) / 2 * 255;
const List<double> _grayscaleContrastMatrix = [
  0.2126 * _kContrast,
  0.7152 * _kContrast,
  0.0722 * _kContrast,
  0,
  _kContrastOffset, //
  0.2126 * _kContrast,
  0.7152 * _kContrast,
  0.0722 * _kContrast,
  0,
  _kContrastOffset, //
  0.2126 * _kContrast,
  0.7152 * _kContrast,
  0.0722 * _kContrast,
  0,
  _kContrastOffset, //
  0, 0, 0, 1, 0,
];

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

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorRamps.blue600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              AppColorRamps.blue600,
              BlendMode.screen,
            ),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(_grayscaleContrastMatrix),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.error, color: Colors.red),
              ),
            ),
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

    for (var y = _spacing / 2; y < size.height; y += _spacing) {
      for (var x = _spacing / 2; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
