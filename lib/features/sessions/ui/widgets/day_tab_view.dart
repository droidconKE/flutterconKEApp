import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/l10n/l10n.dart';

class DayTabView extends StatelessWidget {
  const DayTabView({
    required this.day,
    required this.date,
    required this.isActive,
    super.key,
  });

  final int day;
  final String date;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Tab(
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? ThemeColors.orangeDroidconColor
              : ThemeColors.blueGreenDroidconColor.withOpacity(.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            AutoSizeText(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: isActive
                    ? Colors.white
                    : isLightMode
                        ? Colors.black
                        : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            AutoSizeText(
              l10n.day(day),
              style: TextStyle(
                fontSize: 16,
                color: isActive
                    ? Colors.white
                    : isLightMode
                        ? Colors.black
                        : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
