import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/feedback/cubit/send_feedback_cubit.dart';
import 'package:fluttercon/features/feedback/widgets/back_button.dart';
import 'package:fluttercon/features/feedback/widgets/custom_appbar.dart';
import 'package:fluttercon/features/feedback/widgets/emoji_container.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:go_router/go_router.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController feedbackController = TextEditingController();
  int? selectedRating;
  int? selectedEmojiIndex;

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendFeedbackCubit(apiRepository: ApiRepository()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const FeedbackCustomAppBar(),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Your feedback helps us improve',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: ThemeColors.blueDroidconColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(child: Text('How is/was the event?')),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  EmojiContainer(
                    path: 'assets/images/sad_emoji.png',
                    isSelected: selectedEmojiIndex == 1,
                    onTap: () {
                      setState(() {
                        selectedRating = 1;
                        selectedEmojiIndex = 1;
                      });
                    },
                  ),
                  EmojiContainer(
                    path: 'assets/images/neutral_emoji.png',
                    isSelected: selectedEmojiIndex == 2,
                    onTap: () {
                      setState(() {
                        selectedRating = 2;
                        selectedEmojiIndex = 2;
                      });
                    },
                  ),
                  EmojiContainer(
                    path: 'assets/images/happy_emoji.png',
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
                      decoration: const InputDecoration(
                        fillColor: Color.fromRGBO(245, 245, 245, 1),
                        hintText: 'Type message here',
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
                              const SnackBar(
                                content:
                                    Text('Feedback submitted successfully!'),
                              ),
                            );
                            context.pop();
                          },
                          error: (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $message'),
                              ),
                            );
                          },
                        );
                      },
                      builder: (context, state) {
                        return _buildSubmitButton(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.blueDroidconColor,
            ),
            onPressed: () {
              final feedback = feedbackController.text;
              if (feedback.isNotEmpty && selectedRating != null) {
                context.read<SendFeedbackCubit>().sendFeedback(
                      feedback: feedback,
                      rating: selectedRating,
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                    'Please ensure you have selected a rating and '
                    'written your feedback',
                  )),
                );
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
