import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/widgets/app_bar/app_bar.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/feed/cubit/feed_cubit.dart';
import 'package:fluttercon/features/feed/cubit/share_feed_post_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    return Scaffold(
      appBar: const CustomAppBar(selectedIndex: 1),
      body: BlocBuilder<FetchFeedCubit, FetchFeedState>(
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
                          onTap: () async => context
                              .read<ShareFeedPostCubit>()
                              .sharePost(feed),
                          child: BlocBuilder<ShareFeedPostCubit,
                              ShareFeedPostState>(
                            builder: (context, state) => state.maybeWhen(
                              loading: () => const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              ),
                              orElse: () => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Share',
                                    style: TextStyle(
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
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
