import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/speaker.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

class SpeakerGridTile extends StatelessWidget {
  const SpeakerGridTile({required this.speaker, super.key});
  final Speaker speaker;

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
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              speaker.name,
              style: const TextStyle(
                color: ThemeColors.blueDroidconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              speaker.biography,
              overflow: TextOverflow.clip,
              maxLines: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(onPressed: () {}, child: const Text('SESSION')),
          ],
        ),
      ),
    );
  }
}
