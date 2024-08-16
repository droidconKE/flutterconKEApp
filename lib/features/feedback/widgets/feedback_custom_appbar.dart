import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/features/feedback/widgets/back_button.dart';

class FeedbackCustomAppBar extends StatelessWidget {
  const FeedbackCustomAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            AppAssets.feedbackBanner,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0 * 3),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              backButton(context),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Text(
                      'Feedback',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
