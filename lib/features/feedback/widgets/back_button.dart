import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

Widget backButton(BuildContext context) {
  return InkWell(
    child: SvgPicture.asset(
      'assets/images/back.svg',
      semanticsLabel: 'Doctors',
      width: 40,
      height: 40,
    ),
    onTap: () => context.pop(),
  );
}
