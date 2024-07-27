import 'package:flutter/material.dart';
import 'package:fluttercon/common/widgets/bottom_nav/app_nav_icon.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

class UserProfileIcon extends StatefulWidget {
  const UserProfileIcon({super.key});

  @override
  State<UserProfileIcon> createState() => _UserProfileIconState();
}

class _UserProfileIconState extends State<UserProfileIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Container(
        height: 30,
        width: 30,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeColors.tealColor,
        ),
        child: const AppNavIcon('locked', color: Colors.white, height: 15),
      ),
    );
  }
}
