import 'dart:io';

import 'package:flutter/material.dart';

bool isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
bool isMobile = Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;

String getThemeModeString(ThemeMode themeMode) {
  return switch (themeMode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    _ => 'System Theme'
  };
}
