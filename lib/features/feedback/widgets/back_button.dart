import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:go_router/go_router.dart';

Widget backButton(BuildContext context) {
  return InkWell(
    child: SvgPicture.asset(
      AppAssets.backIcon,
      width: 25,
      height: 25,
    ),
    onTap: () => context.pop(),
  );
}
