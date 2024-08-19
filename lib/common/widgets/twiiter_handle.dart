import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/l10n/l10n.dart';

class TwitterHandleBody extends StatelessWidget {
  const TwitterHandleBody({
    required this.name,
    this.twitterUrl,
    super.key,
  });

  final String? twitterUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (_, colorScheme) = Misc.getTheme(context);

    return Row(
      children: [
        Text(
          l10n.twitterHandle,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            if (twitterUrl != null) {
              Misc.launchURL(Uri.parse(twitterUrl!));
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
              SvgPicture.asset(
                AppAssets.iconTwitter,
                colorFilter: ColorFilter.mode(
                  colorScheme.primary,
                  BlendMode.srcIn,
                ),
                height: 20,
              ),
              const SizedBox(width: 3),
              Text(name),
            ],
          ),
        ),
      ],
    );
  }
}
