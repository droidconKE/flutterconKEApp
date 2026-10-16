import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/pill_badge.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/features/sessions/cubit/bookmark_session_cubit.dart';
import 'package:fluttercon/features/sessions/cubit/fetch_grouped_sessions_cubit.dart';
import 'package:fluttercon/features/sessions/ui/widgets/session_time_badge.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:intl/intl.dart';

/// Matches the web's `SessionListCard.tsx` (flutterconKE2024Web, `dev`
/// branch) — rounded-4xl card, primary-colored border, time-badge box,
/// level/format pill badges. See docs/design/REBRAND-PLAN.md, Phase 3
/// (flutterconKEApp#260).
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
    final (_, colorScheme) = Misc.getTheme(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: Corners.s32Border,
        border: Border.all(color: colorScheme.primary),
      ),
      padding: const EdgeInsets.all(16),
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
                if (session.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  AutoSizeText(
                    session.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 3,
                  ),
                ],
                const SizedBox(height: 8),
                AutoSizeText(
                  l10n.sessionFullTimeAndVenue(
                    DateFormat.Hm().format(session.startDateTime),
                    DateFormat.Hm().format(session.endDateTime),
                    session.rooms
                        .map((room) => room.title)
                        .join(', ')
                        .toUpperCase(),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ThemeColors.greyTextColor,
                  ),
                ),
                if (session.speakers.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: session.speakers
                        .map(
                          (speaker) => Text(
                            speaker.name ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          BlocConsumer<BookmarkSessionCubit, BookmarkSessionState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (loaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: AutoSizeText(loaded.message)),
                  );
                },
                error: (error) => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: AutoSizeText(error.message))),
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
                              ? ThemeColors.flutterconMagenta
                              : colorScheme.primary,
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
    );
  }
}
