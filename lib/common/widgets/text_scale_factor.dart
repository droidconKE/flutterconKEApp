import 'package:flutter/material.dart';

class TextScaleFactor extends StatelessWidget {
  const TextScaleFactor({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
      child: child,
    );
  }
}
