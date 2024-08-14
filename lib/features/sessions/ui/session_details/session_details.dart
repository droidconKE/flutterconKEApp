import 'package:flutter/material.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:intl/intl.dart';

class SessionDetailsPage extends StatelessWidget {
  const SessionDetailsPage({
    required this.session,
    super.key,
  });

  final Session session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        title: const Text(
          'Session Details',
          style: TextStyle(color: Colors.black),
        ),
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Flexible(
                      child: Icon(
                        Icons.android_outlined,
                        color: ThemeColors.orangeColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Speaker',
                      style: TextStyle(
                        color: ThemeColors.orangeColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      session.speakers
                          .map((speaker) => speaker.name)
                          .join(', '),
                      style: const TextStyle(
                        color: ThemeColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.star_border_outlined,
                        color: ThemeColors.blueColor,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              session.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              session.description,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                session.sessionImage ?? 'https://via.placeholder.com/150',
                height: 170,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.withOpacity(.5)),
            const SizedBox(height: 16),
            if (session.rooms.isNotEmpty)
              Text(
                l10n.sessionFullTimeAndVenue(
                  DateFormat.Hm().format(session.startDateTime),
                  DateFormat.Hm().format(session.endDateTime),
                  session.rooms
                      .map((room) => room.title)
                      .join(', ')
                      .toUpperCase(),
                ),
              ),
            Chip(
              label: Text('#${session.sessionLevel.toUpperCase()}'),
              side: BorderSide.none,
              backgroundColor: ThemeColors.blackColor,
              labelStyle: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.withOpacity(.5)),
            const SizedBox(height: 16),
            if (session.speakers
                .where((speaker) => speaker.twitter != null)
                .isNotEmpty)
              ...session.speakers
                  .where((speaker) => speaker.twitter != null)
                  .map(
                    (speaker) => Row(
                      children: [
                        const Text(
                          'Twitter Handle',
                          style: TextStyle(
                            color: ThemeColors.blackColor,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              // Add a Twitter Icon here
                              Text(speaker.name),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 128),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ThemeColors.orangeColor,
        child: const Icon(Icons.reply),
        onPressed: () {},
      ),
    );
  }
}
