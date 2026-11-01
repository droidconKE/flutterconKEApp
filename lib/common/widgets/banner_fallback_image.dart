import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';

/// A network image that falls back to [EventBanner] when [imageUrl]
/// has no real image (see [Misc.isMissingImage]) or fails to load.
class BannerFallbackImage extends StatelessWidget {
  const BannerFallbackImage({
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (Misc.isMissingImage(imageUrl)) {
      return EventBanner(height: height, width: width);
    }
    return LayoutBuilder(
      builder: (context, constraints) => CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        // fitHeight draws at [height]; cover fills the box, so decode at its
        // longer side (session images are roughly square).
        memCacheHeight: fit == BoxFit.fitHeight
            ? Misc.decodeSize(context, height)
            : null,
        memCacheWidth: fit == BoxFit.fitHeight
            ? null
            : Misc.decodeSize(
                context,
                math.max(
                  width != null && width!.isFinite
                      ? width!
                      : constraints.maxWidth,
                  height ?? 0,
                ),
              ),
        placeholder: (_, __) => SizedBox(
          height: height ?? 150,
          width: double.infinity,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, __, ___) => EventBanner(height: height, width: width),
      ),
    );
  }
}

/// The event's empty-state artwork, the same image fluttercondev.ke shows for
/// sessions without one.
///
/// Like the site, it covers its box and is cropped from the centre. A missing
/// [height] or [width] is derived from the other: a height alone gives a
/// square (matching a square session image drawn with `BoxFit.fitHeight`), a
/// width alone gives 16:9 (the site's `aspect-video`). It's decoded at the
/// size it's drawn at, not the asset's full 1080x1080.
class EventBanner extends StatelessWidget {
  const EventBanner({this.height, this.width, super.key});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = height != null && height!.isFinite ? height : null;
        // No width: square to the height. An infinite width
        // (`double.infinity`): fill whatever width the parent allows.
        double? w;
        if (width == null) {
          w = h;
        } else if (width!.isFinite) {
          w = width;
        }
        w ??= constraints.hasBoundedWidth ? constraints.maxWidth : 150;
        w = w.clamp(0, constraints.maxWidth);
        return Image.asset(
          AppAssets.emptyState,
          height: h ?? w * 9 / 16,
          width: w,
          fit: BoxFit.cover,
          cacheWidth: Misc.decodeSize(context, math.max(w, h ?? 0)),
          excludeFromSemantics: true,
        );
      },
    );
  }
}
