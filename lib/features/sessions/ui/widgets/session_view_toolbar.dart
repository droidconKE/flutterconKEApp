import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/app_bar/session_filter.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Secondary toolbar for the Sessions screen: the compact/schedule view
/// toggle and the filter trigger. Lives below the app bar (as the first
/// header sliver in `SessionsScreen`'s `NestedScrollView`) rather than
/// crowding into the main app bar alongside the logo — see
/// docs/design/REBRAND-PLAN.md for context on why this moved.
class SessionViewToolbar extends StatelessWidget {
  const SessionViewToolbar({
    required this.selectedScheduleIndex,
    required this.onCompactTapped,
    required this.onScheduleTapped,
    super.key,
  });

  final int selectedScheduleIndex;
  final VoidCallback onCompactTapped;
  final VoidCallback onScheduleTapped;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (_, colorScheme) = Misc.getTheme(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: Corners.pillBorder,
              border: Border.all(color: colorScheme.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ViewToggleIcon(
                  assetPath: AppAssets.listAltIcon,
                  isSelected: selectedScheduleIndex == 0,
                  onTap: onCompactTapped,
                ),
                _ViewToggleIcon(
                  assetPath: AppAssets.viewAgendaIcon,
                  isSelected: selectedScheduleIndex == 1,
                  onTap: onScheduleTapped,
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showFilterSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: Corners.pillBorder,
                border: Border.all(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    l10n.filter,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    AppAssets.filterIcon,
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final l10n = context.l10n;
    final (_, colorScheme) = Misc.getTheme(context);

    WoltModalSheet.show<dynamic>(
      context: context,
      barrierDismissible: true,
      pageListBuilder: (context) => [
        WoltModalSheetPage(
          backgroundColor: colorScheme.secondaryContainer,
          leadingNavBarWidget: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.filterIcon,
                  colorFilter: ColorFilter.mode(
                    colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                AutoSizeText(
                  l10n.filter,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          trailingNavBarWidget: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: AutoSizeText(
                l10n.cancel.toUpperCase(),
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
  }
}

class _ViewToggleIcon extends StatelessWidget {
  const _ViewToggleIcon({
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (_, colorScheme) = Misc.getTheme(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: Corners.pillBorder,
        ),
        child: SvgPicture.asset(
          assetPath,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.white : Colors.grey,
            BlendMode.srcIn,
          ),
          height: 18,
        ),
      ),
    );
  }
}
