import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/data/enums/social_platform.dart';
import 'package:fluttercon/common/data/models/local/local_feed.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/widgets/app_bar/app_bar.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/feed/cubit/feed_cubit.dart';
import 'package:fluttercon/features/feed/cubit/share_feed_post_cubit.dart';
import 'package:fluttercon/features/feed/widgets/social_media_button.dart';
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

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: const CustomAppBar(selectedIndex: 1),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<FetchFeedCubit>().fetchFeeds(forceRefresh: true),
        child: BlocBuilder<FetchFeedCubit, FetchFeedState>(
          builder: (context, state) => state.maybeWhen(
            loaded: (fetchedFeeds) => ListView.separated(
              itemCount: fetchedFeeds.length,
              itemBuilder: (context, index) {
                final feed = fetchedFeeds[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Text(
                        feed.body,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          AppAssets.session1,
                          height: 209,
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
                                    backgroundColor: const Color(0xFFF6F6F8),
                                    mainContentSliversBuilder: (context) =>
                                        <Widget>[_buildPage(feed, l10n)],
                                  ),
                                ],
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.share,
                                  style: const TextStyle(
                                    color: ThemeColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(
                                  AppAssets.iconShare,
                                  colorFilter: const ColorFilter.mode(
                                    ThemeColors.blueColor,
                                    BlendMode.srcIn,
                                  ),
                                  height: 32,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(timeago.format(feed.createdAt)),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Color.fromARGB(50, 112, 112, 112)),
              ),
            ),
            error: (message) => Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : ThemeColors.blueColor,
                    fontSize: 18,
                  ),
            ),
            orElse: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(LocalFeedEntry feed, AppLocalizations l10n) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<ShareFeedPostCubit, ShareFeedPostState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.postShared),
                    ),
                  );
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message.message)),
                  );
                },
              );
            },
            builder: (context, state) {
              return Container(
                constraints: const BoxConstraints(minHeight: 250),
                child: state.maybeWhen(
                  loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  orElse: () => Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                AppAssets.iconShare,
                                colorFilter: const ColorFilter.mode(
                                  ThemeColors.blackColor,
                                  BlendMode.srcIn,
                                ),
                                height: 32,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.share,
                                style: const TextStyle(
                                  color: ThemeColors.blackColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
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
                            callBack: () async =>
                                context.read<ShareFeedPostCubit>().sharePost(
                                      body: feed.body,
                                      fileUrl: feed.image,
                                      platform: SocialPlatform.twitter,
                                    ),
                            label: l10n.twitter,
                            iconPath: AppAssets.iconTwitter,
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          SocialMediaButton(
                            callBack: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.comingSoon),
                              ),
                            ),
                            // callBack: () async =>
                            //     context.read<ShareFeedPostCubit>().sharePost(
                            //           body: feed.body,
                            //           fileUrl: feed.image,
                            //           platform: SocialPlatform.facebook,
                            //         ),
                            label: l10n.facebook,
                            iconPath: AppAssets.iconFacebook,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: <Widget>[
                          SocialMediaButton(
                            callBack: () async =>
                                context.read<ShareFeedPostCubit>().sharePost(
                                      body: feed.body,
                                      fileUrl: feed.image,
                                      platform: SocialPlatform.whatsapp,
                                    ),
                            label: l10n.whatsApp,
                            iconPath: AppAssets.iconWhatsApp,
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          SocialMediaButton(
                            callBack: () async =>
                                context.read<ShareFeedPostCubit>().sharePost(
                                      body: feed.body,
                                      fileUrl: feed.image,
                                      platform: SocialPlatform.telegram,
                                    ),
                            label: l10n.telegram,
                            iconPath: AppAssets.iconTelegram,
                          ),
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
      );
}
