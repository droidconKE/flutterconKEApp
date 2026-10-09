import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/utils/router.dart';
import 'package:fluttercon/common/widgets/pill_badge.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/features/sessions/cubit/bookmark_session_cubit.dart';
import 'package:fluttercon/features/sessions/cubit/fetch_grouped_sessions_cubit.dart';
import 'package:fluttercon/features/sessions/ui/widgets/session_time_badge.dart';
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
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: Corners.s32Border,
        border: Border.all(color: colorScheme.primary),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: session.sessionImage,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => const SizedBox(
                height: 150,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) => const SizedBox(
                height: 150,
                width: double.infinity,
                child: Icon(Icons.error, color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SessionTimeBadge(startDateTime: session.startDateTime),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          session.isKeynote
                              ? '${l10n.keynote}: ${session.title}'
                              : session.title,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (!session.isServiceSession) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              PillBadge(
                                label: session.isKeynote
                                    ? '#${l10n.keynote}'
                                    : '#${session.sessionLevel}',
                                variant: PillBadgeVariant.level,
                              ),
                              PillBadge(
                                label: session.sessionFormat,
                                variant: PillBadgeVariant.format,
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        AutoSizeText(
                          l10n.sessionTimeAndVenue(
                            DateFormat.Hm().format(session.startDateTime),
                            session.rooms.map((room) => room.title).join(', '),
                          ),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16) +
                  const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: session.speakers
                        .map(
                          (speaker) => GestureDetector(
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
                                  color: ThemeColors.flutterconMagenta,
                                  width: 2,
                                ),
                                borderRadius: Corners.s12Border,
                              ),
                              child: ClipRRect(
                                borderRadius: Corners.s10Border,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: speaker.avatar!,
                                  placeholder: (_, __) => const SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => const SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
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
                            SnackBar(content: AutoSizeText(loaded.message)),
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
                                ? ThemeColors.flutterconMagenta
                                : colorScheme.primary,
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
                                ? ThemeColors.flutterconMagenta
                                : colorScheme.primary,
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
