import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:go_router/go_router.dart';

class SpeakerGridTile extends StatelessWidget {
  const SpeakerGridTile({required this.speaker, super.key});
  final LocalSpeaker speaker;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: ThemeColors.lightGrayBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 4.5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeColors.tealColor,
                    width: 2,
                  ),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: speaker.avatar,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              speaker.name,
              maxLines: 1,
              style: const TextStyle(
                color: ThemeColors.blueDroidconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              speaker.tagline ?? '',
              overflow: TextOverflow.clip,
              maxLines: 3,
            ),
            const SizedBox(height: 10),
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
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Details'.toUpperCase(),
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
