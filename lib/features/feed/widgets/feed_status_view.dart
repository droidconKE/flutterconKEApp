import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/button_styles.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/l10n/l10n.dart';

/// A centered icon + title + message state for the Feed screen, used for
/// both the empty ("no posts yet") and error ("couldn't load the feed")
/// cases — previously these just rendered the raw message as a bare
/// top-left text, including the literal API error string (e.g. "Not
/// found") with no context or way to retry.
class FeedStatusView extends StatelessWidget {
  const FeedStatusView({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLightMode
                    ? AppColorRamps.blue50
                    : ThemeColors.flutterconBlue.withValues(alpha: 0.15),
              ),
              child: Icon(icon, size: 48, color: colorScheme.primary),
            ),
            const SizedBox(height: 24),
            AutoSizeText(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            AutoSizeText(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isLightMode
                    ? ThemeColors.greyTextColor
                    : ThemeColors.lightGreyTextColor,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                style: AppButtonStyles.primary(context),
                onPressed: onRetry,
                child: Text(context.l10n.tryAgain.toUpperCase()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
