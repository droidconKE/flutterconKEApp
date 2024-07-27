import 'package:flutter/material.dart';

import 'package:fluttercon/core/theme/theme_colors.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'All sessions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? ThemeColors.tealColor
                        : ThemeColors.blueDroidconColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
