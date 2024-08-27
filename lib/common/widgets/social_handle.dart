import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/l10n/l10n.dart';

class SocialHandleBody extends StatelessWidget {
  const SocialHandleBody({
    required this.name,
    this.twitterUrl,
    this.linkedinUrl,
    super.key,
  });

  final String name;
  final String? twitterUrl;
  final String? linkedinUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (_, colorScheme) = Misc.getTheme(context);
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      width: size.width,
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          AutoSizeText(
            twitterUrl != null ? l10n.twitterHandle : l10n.linkedin,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: ElevatedButton(
              onPressed: () {
                if (twitterUrl != null || linkedinUrl != null) {
                  Misc.launchURL(Uri.parse(twitterUrl ?? linkedinUrl ?? ''));
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (twitterUrl != null)
                    SvgPicture.asset(
                      AppAssets.iconTwitter,
                      colorFilter: ColorFilter.mode(
                        colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      height: 20,
                    ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: AutoSizeText(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
