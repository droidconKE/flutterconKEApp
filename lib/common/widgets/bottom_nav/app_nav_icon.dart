import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppNavIcon extends StatelessWidget {
  const AppNavIcon(
    this.name, {
    super.key,
    this.semanticsLabel,
    this.color, // = Colors.black,
    this.height,
    this.width,
  });
  final String name;
  final String? semanticsLabel;
  final Color? color;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      semanticsLabel: semanticsLabel,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : ColorFilter.mode(IconTheme.of(context).color!, BlendMode.srcIn),
      height: height ?? IconTheme.of(context).size,
      width: width ?? IconTheme.of(context).size,
    );
  }
}
