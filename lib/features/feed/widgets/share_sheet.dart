import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercon/common/data/enums/social_platform.dart';
import 'package:fluttercon/common/data/models/local/local_feed.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/feed/cubit/share_feed_post_cubit.dart';
import 'package:fluttercon/features/feed/widgets/social_media_button.dart';
import 'package:fluttercon/l10n/l10n.dart';

class ShareSheet extends StatelessWidget {
  const ShareSheet({
    required this.feed,
    super.key,
  });

  final LocalFeedEntry feed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);
    return SliverToBoxAdapter(
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
                          onTap: () => Navigator.of(context).pop(),
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
                          callBack: () async =>
                              context.read<ShareFeedPostCubit>().sharePost(
                                    body: feed.body,
                                    fileUrl: feed.image,
                                    platform: SocialPlatform.twitter,
                                  ),
                          label: l10n.twitter,
                          iconPath: AppAssets.iconTwitter,
                        ),
                        const SizedBox(width: 24),
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
                                    platform: SocialPlatform.telegram,
                                  ),
                          label: l10n.telegram,
                          iconPath: AppAssets.iconTelegram,
                        ),
                        const SizedBox(width: 24),
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
    );
  }
}
