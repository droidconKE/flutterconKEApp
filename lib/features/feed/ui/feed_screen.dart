import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/common/widgets/app_bar/app_bar.dart';
import 'package:fluttercon/features/feed/cubit/feed_cubit.dart';
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
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
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
                                        <Widget>[
                                      ShareSheet(feed: feed, l10n: l10n),
                                    ],
                                  ),
                                ],
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
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
                          Text(
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
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Color.fromARGB(50, 112, 112, 112)),
              ),
            ),
            error: (message) => Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    fontSize: 18,
                  ),
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
