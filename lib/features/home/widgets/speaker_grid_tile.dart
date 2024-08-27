import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class SpeakerGridTile extends StatelessWidget {
  const SpeakerGridTile({required this.speaker, super.key});
  final LocalSpeaker speaker;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Card(
      elevation: 4,
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width / 4.5,
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
                  imageUrl: speaker.avatar,
                  height: 100,
                  placeholder: (_, __) => const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            AutoSizeText(
              speaker.name,
              maxLines: 1,
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            AutoSizeText(
              speaker.tagline ?? '',
              overflow: TextOverflow.clip,
              maxLines: 3,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context)
                    .push(FlutterConRouter.speakerDetailsRoute, extra: speaker),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(
                    color: ThemeColors.blueGreenDroidconColor,
                    width: 2,
                  ),
                  backgroundColor: colorScheme.surface,
                ),
                child: AutoSizeText(
                  l10n.details.toUpperCase(),
                  style: const TextStyle(
                    color: ThemeColors.blueGreenDroidconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
