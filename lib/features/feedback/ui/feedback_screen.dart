import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/utils/constants/app_assets.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/feedback/cubit/send_feedback_cubit.dart';
import 'package:fluttercon/features/feedback/widgets/emoji_container.dart';
import 'package:fluttercon/features/feedback/widgets/feedback_custom_appbar.dart';
import 'package:fluttercon/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const FeedbackCustomAppBar(),
            const SizedBox(height: 20),
            Center(
              child: Text(
                l10n.yourFeedback,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: ThemeColors.blueDroidconColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            Center(child: Text(l10n.howWasFluttercon)),
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
                      fillColor: Color.fromRGBO(245, 245, 245, 1),
                      hintText: l10n.typeYourFeedback,
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(112, 112, 112, 1),
                        fontSize: 14,
                      ),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 10),
                  BlocConsumer<SendFeedbackCubit, SendFeedbackState>(
                    listener: (context, state) {
                      state.whenOrNull(
                        loaded: (feedback, rating) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.feedbackSubmitted)),
                          );
                          context.pop();
                        },
                        error: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
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
                                backgroundColor: ThemeColors.blueColor,
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
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.feedbackError),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                l10n.submitFeedback.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
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
