import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:injectable/injectable.dart';

@singleton
class ShareRepository {
  final appinioSocialShare = AppinioSocialShare();

  Future<Map<String, bool>> getInstalledApps() {
    return appinioSocialShare.getInstalledApps();
  }

  Future<String> shareToTelegram(String message, String? filePath) async {
    try {
      return await appinioSocialShare.android
          .shareToTelegram(message, filePath);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> shareToWhatsApp(String message, String? filePath) async {
    try {
      return await appinioSocialShare.android
          .shareToWhatsapp(message, filePath);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> shareToTwitter(String message, String? filePath) async {
    try {
      return await appinioSocialShare.android.shareToTwitter(message, filePath);
    } catch (e) {
      rethrow;
    }
  }
}
