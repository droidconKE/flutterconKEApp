import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResolvedImage extends StatelessWidget {
  const ResolvedImage({
    required this.imageUrl,
    super.key,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return imageUrl.contains('.svg')
        ? SvgPicture.network(imageUrl)
        : CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (_, __) => const SizedBox(
              height: 150,
              width: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) => const SizedBox(
              height: 150,
              width: double.infinity,
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          );
  }
}
