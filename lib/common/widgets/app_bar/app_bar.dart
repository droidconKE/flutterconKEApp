import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/widgets/app_bar/feedback_button.dart';
import 'package:fluttercon/common/widgets/app_bar/user_profile_icon.dart';
import 'package:fluttercon/core/di/injectable.dart';
import 'package:fluttercon/core/local_storage.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({required this.selectedIndex, super.key});
  final int selectedIndex;

  @override
  State<CustomAppBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomAppBar> {
  /// This is used for the swipe drag gesture on the bottom nav bar
  LocalStorage localStorage = getIt<LocalStorage>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.light;

    final droidconLogo = GestureDetector(
      onTap: () {
        /*showDialog(
            context: context,
            builder: (context) {
              return const ThemeDialog();
            });*/
      },
      child: Image.asset(
        isDarkTheme ? AppAssets.droidconLogoWhite : AppAssets.droidconLogo,
        scale: 2,
      ),
    );

    return Row(
      children: [
        droidconLogo,
        const Spacer(),
        FeedbackButton(selectedIndex: widget.selectedIndex),
        const SizedBox(width: 15),
        const UserProfileIcon(),
      ],
    );
  }
}
