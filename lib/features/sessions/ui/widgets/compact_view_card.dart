import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/sessions/cubit/bookmark_session_cubit.dart';
import 'package:fluttercon/features/sessions/cubit/fetch_grouped_sessions_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:intl/intl.dart';

class CompactViewCard extends StatelessWidget {
  const CompactViewCard({
    required this.session,
    required this.listIndex,
    super.key,
  });

  final LocalSession session;
  final int listIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Column(
          children: [
            Text(
              DateFormat.Hm().format(
                DateTime.parse('2022-01-01 ${session.startTime}'),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              DateTime.parse('2022-01-01 ${session.startTime}').hour > 11
                  ? 'PM'
                  : 'AM',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        title: Text(
          session.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              session.description,
              style: const TextStyle(fontSize: 16),
              maxLines: 3,
            ),
            if (session.rooms.isNotEmpty) const SizedBox(height: 8),
            if (session.rooms.isNotEmpty)
              Text(
                l10n.sessionFullTimeAndVenue(
                  DateFormat.Hm().format(
                    session.startDateTime,
                  ),
                  DateFormat.Hm().format(
                    session.endDateTime,
                  ),
                  session.rooms
                      .map((room) => room.title)
                      .join(', ')
                      .toUpperCase(),
                ),
              ),
            if (session.speakers.isNotEmpty) const SizedBox(height: 8),
            if (session.speakers.isNotEmpty)
              Row(
                children: [
                  const Flexible(
                    child: Icon(
                      Icons.android_outlined,
                      color: ThemeColors.blueColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 8,
                    child: Text(
                      session.speakers
                          .map((speaker) => speaker.name)
                          .join(', '),
                      style: const TextStyle(
                        color: ThemeColors.blueColor,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: BlocConsumer<BookmarkSessionCubit, BookmarkSessionState>(
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
              loading: (loadingIndex) => loadingIndex == listIndex
                  ? const SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(),
                    )
                  : IconButton(
                      onPressed: () => context
                          .read<BookmarkSessionCubit>()
                          .bookmarkSession(
                            sessionId: session.serverId,
                            index: listIndex,
                          )
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
              orElse: () => IconButton(
                onPressed: () => context
                    .read<BookmarkSessionCubit>()
                    .bookmarkSession(
                      sessionId: session.serverId,
                      index: listIndex,
                    )
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
      ),
    );
  }
}
