import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

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
    Logger().d('ResolvedImage: $imageUrl');
    final resolvedHeight = height ?? size.height * .15;
    final resolvedWidth = width ?? size.width * .3;
    return imageUrl.contains('.svg')
        ? SvgPicture.network(imageUrl, height: height, width: width)
        : CachedNetworkImage(
            imageUrl: imageUrl,
            height: resolvedHeight,
            width: resolvedWidth,
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
