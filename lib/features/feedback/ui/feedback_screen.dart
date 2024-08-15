import 'package:flutter/material.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/feedback/widgets/custom_appbar.dart';
import 'package:fluttercon/features/feedback/widgets/emoji_container.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const FeedbackCustomAppBar(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    EmojiContainer(
                      path: 'assets/images/sad_emoji.png',
                    ),
                    EmojiContainer(
                      path: 'assets/images/neutral_emoji.png',
                    ),
                    EmojiContainer(
                      path: 'assets/images/happy_emoji.png',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const TextField(
                  decoration: InputDecoration(
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColors.blueDroidconColor,
                        ),
                        onPressed: () {
                          // Handle submit feedback
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
