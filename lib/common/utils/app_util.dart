import 'dart:io';

import 'package:flutter/material.dart';

bool isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
bool isMobile = Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;

String getThemeModeString(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.light:
      return 'Light';

    case ThemeMode.dark:
      return 'Dark';

    default:
      return 'System Theme';
  }
}
