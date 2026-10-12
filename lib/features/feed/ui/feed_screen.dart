import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/app_bar/app_bar.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/core/theme/theme_styles.dart';
import 'package:fluttercon/features/feed/cubit/feed_cubit.dart';
import 'package:fluttercon/features/feed/widgets/feed_status_view.dart';
import 'package:fluttercon/features/feed/widgets/share_sheet.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();

    context.read<FetchFeedCubit>().fetchFeeds();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Scaffold(
      appBar: const CustomAppBar(selectedIndex: 1),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<FetchFeedCubit>().fetchFeeds(forceRefresh: true),
        child: BlocBuilder<FetchFeedCubit, FetchFeedState>(
          builder: (context, state) => state.maybeWhen(
            loaded: (fetchedFeeds) => fetchedFeeds.isEmpty
                ? FeedStatusView(
                    icon: Icons.dynamic_feed_outlined,
                    title: l10n.noPosts,
                    message: l10n.noPostsMessage,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: fetchedFeeds.length,
                    itemBuilder: (context, index) {
                      final feed = fetchedFeeds[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: Corners.s32Border,
                          border: Border.all(color: colorScheme.primary),
                        ),
                        child: Column(
                          children: [
                            AutoSizeText(
                              feed.body,
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: Corners.s16Border,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: feed.image,
                                width: double.infinity,
                                placeholder: (_, __) => const SizedBox(
                                  height: 100,
                                  width: double.infinity,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (_, __, ___) => const SizedBox(
                                  height: 100,
                                  width: double.infinity,
                                  child: Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    WoltModalSheet.show<dynamic>(
                                      context: context,
                                      showDragHandle: false,
                                      modalTypeBuilder: (_) =>
                                          WoltModalType.bottomSheet(),
                                      pageListBuilder: (bottomSheetContext) => [
                                        SliverWoltModalSheetPage(
                                          useSafeArea: true,
                                          hasTopBarLayer: false,
                                          backgroundColor: isLightMode
                                              ? ThemeColors
                                                    .lightGrayBackgroundColor
                                              : Colors.black,
                                          mainContentSliversBuilder:
                                              (context) => <Widget>[
                                                ShareSheet(feed: feed),
                                              ],
                                        ),
                                      ],
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AutoSizeText(
                                        l10n.share,
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SvgPicture.asset(
                                        AppAssets.iconShare,
                                        colorFilter: ColorFilter.mode(
                                          colorScheme.primary,
                                          BlendMode.srcIn,
                                        ),
                                        height: 32,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                AutoSizeText(
                                  timeago.format(feed.createdAt),
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                  ),
            error: (message) => FeedStatusView(
              icon: Icons.wifi_off_rounded,
              title: l10n.feedErrorTitle,
              message: message,
              onRetry: () =>
                  context.read<FetchFeedCubit>().fetchFeeds(forceRefresh: true),
            ),
            orElse: () => Center(
              child: CircularProgressIndicator(
                backgroundColor: colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
