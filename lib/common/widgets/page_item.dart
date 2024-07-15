import 'package:flutter/material.dart';

class PageItem {
  final String title;
  final String icon;
  final Widget screen;

  const PageItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
}
