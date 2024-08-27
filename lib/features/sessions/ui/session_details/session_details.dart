import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/enums/social_platform.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/social_handle.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/feed/cubit/share_feed_post_cubit.dart';
import 'package:fluttercon/features/feed/widgets/social_media_button.dart';
import 'package:fluttercon/features/sessions/cubit/bookmark_session_cubit.dart';
import 'package:fluttercon/features/sessions/cubit/fetch_grouped_sessions_cubit.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SessionDetailsPage extends StatelessWidget {
  const SessionDetailsPage({
    required this.session,
    super.key,
  });

  final LocalSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
          color: colorScheme.onSurface,
        ),
        surfaceTintColor: colorScheme.surface,
        title: AutoSizeText(
          l10n.sessionDetails,
          style: TextStyle(color: colorScheme.onSurface),
        ),
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
                Row(
                  children: [
                    const Flexible(
                      child: Icon(
                        Icons.android_outlined,
                        color: ThemeColors.orangeColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AutoSizeText(
                      l10n.speaker,
                      style: const TextStyle(
                        color: ThemeColors.orangeColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AutoSizeText(
                      session.speakers
                          .map((speaker) => speaker.name)
                          .join(', '),
                      style: TextStyle(
                        color: colorScheme.primary,
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
                                content: AutoSizeText(loaded.message),
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
                                  ? ThemeColors.orangeColor
                                  : colorScheme.primary,
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
            AutoSizeText(
              session.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            AutoSizeText(
              session.description,
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: session.sessionImage,
                height: 170,
                fit: BoxFit.fitHeight,
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
            const SizedBox(height: 16),
            Divider(color: Colors.grey.withOpacity(.5)),
            const SizedBox(height: 16),
            if (session.rooms.isNotEmpty)
              AutoSizeText(
                l10n.sessionFullTimeAndVenue(
                  DateFormat.Hm().format(session.startDateTime),
                  DateFormat.Hm().format(session.endDateTime),
                  session.rooms
                      .map((room) => room.title)
                      .join(', ')
                      .toUpperCase(),
                ),
                style: TextStyle(color: colorScheme.onSurface),
              ),
            Chip(
              label: Text('#${session.sessionLevel.toUpperCase()}'),
              side: BorderSide.none,
              backgroundColor: colorScheme.onSurface,
              labelStyle: TextStyle(color: colorScheme.surface),
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
                    (speaker) => SocialHandleBody(
                      name: speaker.name!,
                      twitterUrl: speaker.twitter,
                    ),
                  ),
            const SizedBox(height: 128),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ThemeColors.orangeColor,
        child: BlocBuilder<ShareFeedPostCubit, ShareFeedPostState>(
          builder: (context, state) => state.maybeWhen(
            orElse: () => Transform.flip(
              flipX: true,
              child: const Icon(
                Icons.reply,
                color: Colors.white,
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ),
        onPressed: () => WoltModalSheet.show<dynamic>(
          context: context,
          showDragHandle: false,
          modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
          pageListBuilder: (bottomSheetContext) => [
            SliverWoltModalSheetPage(
              useSafeArea: true,
              hasTopBarLayer: false,
              backgroundColor: colorScheme.secondaryContainer,
              mainContentSliversBuilder: (context) => <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: BlocConsumer<ShareFeedPostCubit, ShareFeedPostState>(
                      listener: (context, state) {
                        state.mapOrNull(
                          loaded: (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: AutoSizeText(l10n.postShared),
                              ),
                            );
                          },
                          error: (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: AutoSizeText(message.message)),
                            );
                          },
                        );
                      },
                      builder: (context, state) {
                        return Container(
                          constraints: const BoxConstraints(
                            minHeight: 250,
                          ),
                          child: state.maybeWhen(
                            loading: () => const Center(
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                            orElse: () => Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.iconShare,
                                          colorFilter: ColorFilter.mode(
                                            colorScheme.onSurface,
                                            BlendMode.srcIn,
                                          ),
                                          height: 32,
                                        ),
                                        const SizedBox(width: 8),
                                        AutoSizeText(
                                          l10n.share,
                                          style: TextStyle(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.of(
                                        context,
                                      ).pop(),
                                      child: AutoSizeText(
                                        l10n.cancel.toUpperCase(),
                                        style: const TextStyle(
                                          color: ThemeColors.greyTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                Row(
                                  children: <Widget>[
                                    SocialMediaButton(
                                      callBack: () async => context
                                          .read<ShareFeedPostCubit>()
                                          .sharePost(
                                            body: session.description,
                                            fileUrl: session.sessionImage,
                                            platform: SocialPlatform.twitter,
                                          ),
                                      label: l10n.twitter,
                                      iconPath: AppAssets.iconTwitter,
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    SocialMediaButton(
                                      callBack: () async => context
                                          .read<ShareFeedPostCubit>()
                                          .sharePost(
                                            body: session.description,
                                            fileUrl: session.sessionImage,
                                            platform: SocialPlatform.whatsapp,
                                          ),
                                      label: l10n.whatsApp,
                                      iconPath: AppAssets.iconWhatsApp,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: <Widget>[
                                    SocialMediaButton(
                                      callBack: () async => context
                                          .read<ShareFeedPostCubit>()
                                          .sharePost(
                                            body: session.description,
                                            fileUrl: session.sessionImage,
                                            platform: SocialPlatform.telegram,
                                          ),
                                      label: l10n.telegram,
                                      iconPath: AppAssets.iconTelegram,
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
