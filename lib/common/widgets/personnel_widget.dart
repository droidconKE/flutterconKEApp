import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';

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
    final (isLightMode, colorScheme) = Misc.getTheme(context);
    final screenSize = MediaQuery.sizeOf(context);
    final defaultWidth = (screenSize.width / 4.5).clamp(50, 120).toDouble();
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: defaultWidth,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: ThemeColors.tealColor,
                width: 2,
              ),
              borderRadius: Corners.s12Border,
            ),
            child: ClipRRect(
              borderRadius: Corners.s10Border,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                memCacheHeight: 100,
                memCacheWidth: defaultWidth.round(),
                placeholder: (_, __) => const SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => const SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: defaultWidth,
            child: Text(
              name,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (designation != null)
            SizedBox(
              width: defaultWidth,
              child: Text(
                designation!,
                maxLines: 1,
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
