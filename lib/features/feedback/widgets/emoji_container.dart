import 'package:flutter/material.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';

class EmojiContainer extends StatelessWidget {
  const EmojiContainer({super.key, this.path});
  final String? path;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ThemeColors.lightGrayColor,
      ),
      child: Image.asset(
        path!,
        width: 40,
        height: 40,
      ),
    );
  }
}
