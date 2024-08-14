import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/feed/cubit/feed_cubit.dart';

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
      body: BlocBuilder<FetchFeedCubit, FetchFeedState>(
        builder: (context, state) => state.maybeWhen(
          loaded: (fetchedFeeds) => ListView.separated(
            itemCount: fetchedFeeds.length,
            itemBuilder: (context, index) {
              final feed = fetchedFeeds[index];
              return Column(
                children: [
                  Text(feed.body),
                  Image.asset(AppAssets.session1),
                  Row(
                    children: [
                      ListTile(
                        leading: const Text('Share'),
                        title: Image.asset(
                          AppAssets.iconShare,
                          color: ThemeColors.blueColor,
                        ),
                      ),
                      Text(feed.createdAt.toString()),
                    ],
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
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
