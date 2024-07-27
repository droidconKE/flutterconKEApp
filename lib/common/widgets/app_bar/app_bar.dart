import 'package:flutter/material.dart';

import '../../../core/local_storage.dart';
import '../../../core/di/injectable.dart';
import '../../utils/constants/app_assets.dart';
import 'feedback_button.dart';
import 'user_profile_icon.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  State<CustomAppBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomAppBar> {
  /// This is used for the swipe drag gesture on the bottom nav bar
  var localStorage = getIt<LocalStorage>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDarkTheme = theme.brightness == Brightness.light;

    var droidconLogo = GestureDetector(
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
