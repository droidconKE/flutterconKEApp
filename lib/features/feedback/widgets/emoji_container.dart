import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

class EmojiContainer extends StatelessWidget {
  const EmojiContainer({
    required this.path,
    super.key,
    this.onTap,
    this.isSelected = false,
  });

  final String path;
  final void Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final (isLightMode, colorScheme) = Misc.getTheme(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? colorScheme.primary : ThemeColors.lightGrayColor,
          boxShadow: [
            if (onTap != null)
              BoxShadow(
                color: (isLightMode ? Colors.black : Colors.white)
                    .withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Image.asset(
          path,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
