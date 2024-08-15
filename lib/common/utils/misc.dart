import 'dart:math';

import 'package:dio/dio.dart';
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

    final tempDir = (await getTemporaryDirectory()).path;

    for (final url in urls) {
      // Download the file
      final filePath = Random().nextInt(1000).toString();

      await Dio().download(
        url,
        tempDir + filePath,
      );

      files.add(XFile(tempDir + filePath));
    }

    return files;
  }
}
