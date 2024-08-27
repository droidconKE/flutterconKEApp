import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/features/feedback/cubit/send_feedback_cubit.dart';
import 'package:fluttercon/features/feedback/widgets/emoji_container.dart';
import 'package:fluttercon/features/feedback/widgets/feedback_custom_appbar.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({
    super.key,
    this.sessionSlug,
  });

  final String? sessionSlug;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final feedbackController = TextEditingController();
  int? selectedRating;
  int? selectedEmojiIndex;

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLightMode, colorScheme) = Misc.getTheme(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const FeedbackCustomAppBar(),
            const SizedBox(height: 20),
            Center(
              child: AutoSizeText(
                l10n.yourFeedback,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: AutoSizeText(
                l10n.howWasFluttercon,
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EmojiContainer(
                  path: AppAssets.sadEmoji,
                  isSelected: selectedEmojiIndex == 1,
                  onTap: () {
                    setState(() {
                      selectedRating = 1;
                      selectedEmojiIndex = 1;
                    });
                  },
                ),
                EmojiContainer(
                  path: AppAssets.neutralEmoji,
                  isSelected: selectedEmojiIndex == 2,
                  onTap: () {
                    setState(() {
                      selectedRating = 2;
                      selectedEmojiIndex = 2;
                    });
                  },
                ),
                EmojiContainer(
                  path: AppAssets.happyEmoji,
                  isSelected: selectedEmojiIndex == 3,
                  onTap: () {
                    setState(() {
                      selectedRating = 3;
                      selectedEmojiIndex = 3;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(245, 245, 245, 1),
                      hintText: l10n.typeYourFeedback,
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(112, 112, 112, 1),
                        fontSize: 14,
                      ),
                    ),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 10),
                  BlocConsumer<SendFeedbackCubit, SendFeedbackState>(
                    listener: (context, state) {
                      state.whenOrNull(
                        loaded: (feedback, rating) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: AutoSizeText(l10n.feedbackSubmitted),
                            ),
                          );
                          context.pop();
                        },
                        error: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: AutoSizeText(message)),
                          );
                        },
                      );
                    },
                    builder: (context, state) => state.maybeWhen(
                      orElse: () => Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                final feedback = feedbackController.text;
                                if (feedback.isNotEmpty &&
                                    selectedRating != null) {
                                  context
                                      .read<SendFeedbackCubit>()
                                      .sendFeedback(
                                        feedback: feedback,
                                        rating: selectedRating!,
                                        sessionSlug: widget.sessionSlug,
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: AutoSizeText(l10n.feedbackError),
                                    ),
                                  );
                                }
                              },
                              child: AutoSizeText(
                                l10n.submitFeedback.toUpperCase(),
                                style: TextStyle(
                                  color: colorScheme.surface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      loading: (index) =>
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
