import 'package:flutter/material.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

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
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Day $day',
              style: TextStyle(
                fontSize: 16,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}