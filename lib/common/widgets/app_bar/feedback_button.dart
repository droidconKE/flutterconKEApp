import 'package:flutter/material.dart';
import 'package:fluttercon/common/widgets/bottom_nav/app_nav_icon.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/l10n/l10n.dart';

class FeedbackButton extends StatelessWidget {
  const FeedbackButton({required this.selectedIndex, super.key});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return selectedIndex == 0
        ? const SizedBox()
        : InkWell(
            onTap: () {
              //context.pushNamed(FeedbackScreen.routeName);
            },
            child: Container(
              height: 30,
              width: 127,
              decoration: BoxDecoration(
                color: ThemeColors.tealColor.withOpacity(.21),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppNavIcon(
                    'smiley-outline',
                    height: 12,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                  ),
                  Text(
                    l10n.feedback,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12),
                  ),
                  const AppNavIcon(
                    'send',
                    height: 12,
                    color: ThemeColors.tealColor,
                  ),
                ],
              ),
            ),
          );
  }
}
