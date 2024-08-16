import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/widgets/app_bar/feedback_button.dart';
import 'package:fluttercon/common/widgets/app_bar/session_filter.dart';
import 'package:fluttercon/common/widgets/app_bar/user_profile_icon.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.selectedIndex,
    super.key,
    this.onCompactTapped,
    this.onScheduleTapped,
    this.selectedScheduleIndex = 0,
  });
  final int selectedIndex;
  final void Function()? onCompactTapped;
  final void Function()? onScheduleTapped;
  final int? selectedScheduleIndex;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.white,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              AppAssets.droidconLogo,
              scale: 2,
            ),
          ),
          const Spacer(),
          if (selectedIndex != 2) FeedbackButton(selectedIndex: selectedIndex),
          if (selectedIndex != 2) const SizedBox(width: 15),
          if (selectedIndex != 2) const UserProfileIcon(),
          if (selectedIndex == 2)
            Row(
              children: [
                GestureDetector(
                  onTap: () => onCompactTapped?.call(),
                  child: SvgPicture.asset(
                    AppAssets.listAltIcon,
                    colorFilter: ColorFilter.mode(
                      selectedScheduleIndex == 0
                          ? ThemeColors.blueColor
                          : Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () => onScheduleTapped?.call(),
                  child: SvgPicture.asset(
                    AppAssets.viewAgendaIcon,
                    colorFilter: ColorFilter.mode(
                      selectedScheduleIndex == 1
                          ? ThemeColors.blueColor
                          : Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    WoltModalSheet.show<dynamic>(
                      context: context,
                      barrierDismissible: true,
                      pageListBuilder: (context) => [
                        WoltModalSheetPage(
                          backgroundColor: const Color(0xFFF6F6F8),
                          leadingNavBarWidget: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.filterIcon,
                                  colorFilter: const ColorFilter.mode(
                                    ThemeColors.blueColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Filter',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: ThemeColors.blueColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          trailingNavBarWidget: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                'Cancel'.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          child: const SessionFilter(),
                        ),
                      ],
                      modalTypeBuilder: (_) => WoltModalType.dialog(),
                    );
                  },
                  child: Row(
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
                ),
              ],
            ),
        ],
      ),
    );
  }
}
