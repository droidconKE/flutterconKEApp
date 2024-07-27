import 'package:flutter/material.dart';

import 'package:fluttercon/core/theme/theme_colors.dart';

class OrganizersCard extends StatefulWidget {
  const OrganizersCard({super.key});

  @override
  State<OrganizersCard> createState() => _OrganizersCardState();
}

class _OrganizersCardState extends State<OrganizersCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.light;
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height / 4,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark ? Colors.black : ThemeColors.lightGrayColor,
      ),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'Organised by:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : ThemeColors.blueColor,
                  fontSize: 18,
                ),
          ),
          const Spacer(),
          //sponsors list
          const Spacer(),
        ],
      ),
    );
  }
}
