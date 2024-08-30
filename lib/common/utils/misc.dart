import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/versioning/build_version.dart' as package_version;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Misc {
  static Future<void> launchURL(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  static Future<List<XFile>> downloadFiles(List<String> urls) async {
    // Download files from the internet
    final files = <XFile>[];

    // Get the path to the temporary directory
    final tempDir = (await getTemporaryDirectory()).path;

    for (final url in urls) {
      // Get file extension
      final ext = url.split('.').last;

      // Generate a file name and create the full path
      final filePath = '$tempDir/${Random().nextInt(1000)}.$ext';

      // Download the file
      await Dio().download(
        url,
        filePath,
      );

      // Add the file to the list of XFiles
      files.add(XFile(filePath));
    }

    return files;
  }

  /// Returns (isLightMode, colorScheme)
  static (bool, ColorScheme) getTheme(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final colorScheme = Theme.of(context).colorScheme;

    return (isLightMode, colorScheme);
  }

  static String getAppVersion() {
    return package_version.packageVersion;
  }
}
