import 'package:url_launcher/url_launcher.dart';

class Misc {
  static Future<void> launchURL(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
