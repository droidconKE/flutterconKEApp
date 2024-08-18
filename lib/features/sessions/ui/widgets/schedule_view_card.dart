import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/sessions/cubit/bookmark_session_cubit.dart';
import 'package:fluttercon/features/sessions/cubit/fetch_grouped_sessions_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScheduleViewCard extends StatelessWidget {
  const ScheduleViewCard({
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
      elevation: 0,
      color: ThemeColors.lightGrayBackgroundColor,
      shadowColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                session.sessionImage ?? 'https://via.placeholder.com/150',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l10n.sessionTimeAndVenue(
                      DateFormat.Hm().format(
                        session.startDateTime,
                      ),
                      session.rooms.map((room) => room.title).join(', '),
                    ),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                session.title,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16) +
                  const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: session.speakers
                        .map(
                          (speaker) => ClipOval(
                            child: GestureDetector(
                              onTap: () => GoRouter.of(context).push(
                                FlutterConRouter.speakerDetailsRoute,
                                extra: speaker,
                              ),
                              child: Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ThemeColors.tealColor,
                                    width: 2,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: speaker.avatar!,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
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
                              .bookmarkSession(sessionId: session.serverId),
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
                              .bookmarkSession(sessionId: session.serverId)
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
            ),
          ],
        ),
      ),
    );
  }
}
