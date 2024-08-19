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
        : CachedNetworkImage(imageUrl: imageUrl);
  }
}
