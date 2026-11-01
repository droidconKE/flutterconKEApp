import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon/versioning/build_version.dart' as package_version;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Misc {
  /// Whether [url] has no real image to show: empty, or the
  /// `via.placeholder.com` default that older builds stored in Isar.
  static bool isMissingImage(String? url) =>
      url == null || url.trim().isEmpty || url.contains('via.placeholder.com');

  /// The pixel size to decode an image at so it stays sharp when drawn at
  /// [logicalSize] on this screen. Pass it as `cacheWidth`/`memCacheWidth`
  /// (or the height equivalent) so a 1080px avatar shown at 50dp isn't held
  /// in memory at full resolution. Returns null (decode at full size) when
  /// [logicalSize] isn't a finite, positive number.
  static int? decodeSize(BuildContext context, double? logicalSize) {
    if (logicalSize == null || !logicalSize.isFinite || logicalSize <= 0) {
      return null;
    }
    return (logicalSize * MediaQuery.devicePixelRatioOf(context)).ceil();
  }

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
      await Dio().download(url, filePath);

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
