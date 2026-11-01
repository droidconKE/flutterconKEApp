import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/banner_fallback_image.dart';

class ResolvedImage extends StatelessWidget {
  const ResolvedImage({
    required this.imageUrl,
    this.height,
    this.width,
    super.key,
  });

  final String imageUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final resolvedHeight = height ?? size.height * .15;
    final resolvedWidth = width ?? size.width * .3;
    if (Misc.isMissingImage(imageUrl)) {
      return EventBanner(height: resolvedHeight, width: resolvedWidth);
    }
    return imageUrl.contains('.svg')
        ? SvgPicture.network(imageUrl, height: height, width: width)
        : CachedNetworkImage(
            imageUrl: imageUrl,
            height: resolvedHeight,
            width: resolvedWidth,
            // Logos are drawn contained, so never wider than the box.
            memCacheWidth: Misc.decodeSize(context, resolvedWidth),
            placeholder: (_, __) => const SizedBox(
              height: 150,
              width: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) => const SizedBox(
              height: 150,
              width: double.infinity,
              child: Icon(Icons.error, color: Colors.red),
            ),
          );
  }
}
