import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton({
    required this.callBack,
    required this.label,
    required this.iconPath,
    super.key,
  });

  final void Function()? callBack;
  final String label;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final (isLightMode, _) = Misc.getTheme(context);
    return Expanded(
      child: InkWell(
        onTap: callBack,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isLightMode ? Colors.white : Colors.black,
            border: Border.all(color: const Color(0xFF7DE1C3)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isLightMode
                      ? ThemeColors.blackColor
                      : const Color(0xFF7DE1C3),
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              const SizedBox(width: 8),
              AutoSizeText(
                label,
                style: TextStyle(
                  color: isLightMode
                      ? ThemeColors.blackColor
                      : const Color(0xFF7DE1C3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
