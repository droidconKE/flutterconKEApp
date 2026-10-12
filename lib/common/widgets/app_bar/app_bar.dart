import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/app_bar/feedback_button.dart';
import 'package:fluttercon/common/widgets/app_bar/user_profile_icon.dart';

/// The shared app bar across all dashboard tabs: logo, feedback pill, and
/// profile avatar. The Sessions tab's view-toggle/filter controls live in
/// their own toolbar below this (`SessionViewToolbar`) rather than crowding
/// in here — see docs/design/REBRAND-PLAN.md.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({required this.selectedIndex, super.key});

  final int selectedIndex;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final (isLightMode, _) = Misc.getTheme(context);
    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              isLightMode
                  ? AppAssets.flutterConLogoLight
                  : AppAssets.flutterConLogoDark,
              height: 24,
            ),
          ),
          const Spacer(),
          FeedbackButton(selectedIndex: selectedIndex),
          const SizedBox(width: 15),
          const UserProfileIcon(),
        ],
      ),
    );
  }
}
