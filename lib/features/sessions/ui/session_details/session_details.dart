import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/sessions/cubit/bookmark_session_cubit.dart';
import 'package:fluttercon/features/sessions/cubit/fetch_grouped_sessions_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
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
                    BlocConsumer<BookmarkSessionCubit, BookmarkSessionState>(
                      listener: (context, state) {
                        state.mapOrNull(
                          loaded: (loaded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loaded.message),
                              ),
                            );
                          },
                        );
                      },
                      builder: (context, state) {
                        return state.maybeWhen(
                          loading: (_) => const SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator(),
                          ),
                          loaded: (message, status) => IconButton(
                            onPressed: () => context
                                .read<BookmarkSessionCubit>()
                                .bookmarkSession(sessionId: session.id),
                            icon: Icon(
                              status == BookmarkStatus.bookmarked
                                  ? Icons.star_rate_rounded
                                  : Icons.star_border_outlined,
                              color: status == BookmarkStatus.bookmarked
                                  ? ThemeColors.orangeColor
                                  : ThemeColors.blueColor,
                              size: 32,
                            ),
                          ),
                          orElse: () => IconButton(
                            onPressed: () => context
                                .read<BookmarkSessionCubit>()
                                .bookmarkSession(sessionId: session.id)
                                .then((_) {
                              if (context.mounted) {
                                context
                                    .read<FetchGroupedSessionsCubit>()
                                    .fetchGroupedSessions();
                              }
                            }),
                            icon: Icon(
                              session.isBookmarked
                                  ? Icons.star_rate_rounded
                                  : Icons.star_border_outlined,
                              color: session.isBookmarked
                                  ? ThemeColors.orangeColor
                                  : ThemeColors.blueColor,
                              size: 32,
                            ),
                          ),
                        );
                      },
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
                        ElevatedButton(
                          onPressed: () {
                            if (speaker.twitter != null) {
                              Misc.launchURL(Uri.parse(speaker.twitter!));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                color: ThemeColors.blueColor,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
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
