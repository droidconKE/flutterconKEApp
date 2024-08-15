import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/widgets/app_bar/feedback_button.dart';
import 'package:fluttercon/common/widgets/app_bar/user_profile_icon.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({required this.selectedIndex, super.key});
  final int selectedIndex;

  @override
  State<CustomAppBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Image.asset(
            AppAssets.droidconLogo,
            scale: 2,
          ),
        ),
        const Spacer(),
        if (widget.selectedIndex != 2)
          FeedbackButton(selectedIndex: widget.selectedIndex),
        if (widget.selectedIndex != 2) const SizedBox(width: 15),
        if (widget.selectedIndex != 2) const UserProfileIcon(),
        if (widget.selectedIndex == 2)
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.listAltIcon,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 24),
              SvgPicture.asset(
                AppAssets.viewAgendaIcon,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 32),
                  Text(
                    'Filter',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    AppAssets.filterIcon,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
