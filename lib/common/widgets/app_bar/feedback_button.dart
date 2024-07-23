import 'package:flutter/material.dart';

import '../../../core/theme/theme_colors.dart';
import '../bottom_nav/app_nav_icon.dart';

class FeedbackButton extends StatelessWidget {
  final int selectedIndex;
  const FeedbackButton({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
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
                    'Feedback',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12),
                  ),
                  const AppNavIcon('send',
                      height: 12, color: ThemeColors.tealColor),
                ],
              ),
            ),
          );
  }
}
