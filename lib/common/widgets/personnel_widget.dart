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
    this.maxWidth,
    super.key,
  });

  final String imageUrl;
  final String name;
  final String? designation;
  final VoidCallback? onTap;

  /// Overrides the default screen-width-based sizing (used by callers that
  /// lay this out in a fixed-width grid cell, e.g. the organising team
  /// grid). Left null for callers like the horizontal speaker list, which
  /// gives this widget unbounded width and so needs the screen-based
  /// fallback.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final (isLightMode, _) = Misc.getTheme(context);
    final width = maxWidth ?? MediaQuery.sizeOf(context).width / 4.5;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: width),
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
            width: width,
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
              width: width,
              child: AutoSizeText(
                designation!,
                maxLines: 2,
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
