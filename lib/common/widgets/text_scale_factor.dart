import 'package:flutter/material.dart';

class TextScaleFactor extends StatelessWidget {
  final Widget child;

  const TextScaleFactor({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1)),
      child: child,
    );
  }
}
