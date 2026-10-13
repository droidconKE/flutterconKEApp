import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/features/home/widgets/speaker_duotone_avatar.dart';

class PersonnelWidget extends StatelessWidget {
  const PersonnelWidget({
    required this.imageUrl,
    required this.name,
    this.designation,
    this.onTap,
    super.key,
  });

  final String imageUrl;
  final String name;
  final String? designation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (isLightMode, _) = Misc.getTheme(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width / 4.5,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: ThemeColors.flutterconMagenta,
                width: 2,
              ),
              borderRadius: Corners.s12Border,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: Corners.s10Border,
                child: SpeakerDuotoneAvatar(imageUrl: imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 4.5,
            child: AutoSizeText(
              name,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ThemeColors.flutterconMagenta,
              ),
            ),
          ),
          if (designation != null)
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 4.5,
              child: AutoSizeText(
                designation!,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isLightMode
                      ? ThemeColors.greyTextColor
                      : ThemeColors.greyAccentColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
