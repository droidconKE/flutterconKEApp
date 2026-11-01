import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';

/// A network image that falls back to the FlutterCon banner when [imageUrl]
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

/// The FlutterCon banner, sized to fill a box of any shape without cropping.
///
/// The banner is drawn whole (`BoxFit.contain`) over a blurred, cover-fitted
/// copy of itself, so the wordmark and "WELCOME" are never cut off and any
/// leftover space blends in instead of showing bars. A missing [height] or
/// [width] is derived from the banner's aspect ratio. Both copies are decoded
/// at the size they're drawn at, not the asset's full 3841x2161.
class EventBanner extends StatelessWidget {
  const EventBanner({this.height, this.width, super.key});

  final double? height;
  final double? width;

  static const double _aspectRatio = 3841 / 2161;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        var h = height != null && height!.isFinite ? height : null;
        // No width: size to the banner (like `BoxFit.fitHeight`). An infinite
        // width (`double.infinity`): fill whatever width the parent allows.
        double? w;
        if (width == null) {
          w = h != null ? h * _aspectRatio : null;
        } else if (width!.isFinite) {
          w = width;
        }
        w ??= constraints.hasBoundedWidth ? constraints.maxWidth : 150;
        w = w.clamp(0, constraints.maxWidth);
        h ??= w / _aspectRatio;

        final bannerWidth = w < h * _aspectRatio ? w : h * _aspectRatio;
        return SizedBox(
          width: w,
          height: h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Image.asset(
                    AppAssets.flutterConBanner,
                    fit: BoxFit.cover,
                    cacheWidth: 96,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
              Image.asset(
                AppAssets.flutterConBanner,
                fit: BoxFit.contain,
                cacheWidth: (bannerWidth * dpr).ceil().clamp(1, 3841),
                excludeFromSemantics: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
