import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:injectable/injectable.dart';

@singleton
class ShareRepository {
  final appinioSocialShare = AppinioSocialShare();

  Future<Map<String, bool>> getInstalledApps() {
    return appinioSocialShare.getInstalledApps();
  }

  Future<void> shareToTelegram(String message, String? filePath) async {
    try {
      await appinioSocialShare.android.shareToTelegram(message, filePath);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> shareToWhatsApp(String message, String? filePath) async {
    try {
      await appinioSocialShare.android.shareToWhatsapp(message, filePath);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> shareToFacebook(String message, String filePath) async {
    try {
      await appinioSocialShare.android.shareToFacebook(message, [filePath]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> shareToTwitter(String message, String? filePath) async {
    try {
      await appinioSocialShare.android.shareToTwitter(message, filePath);
    } catch (e) {
      rethrow;
    }
  }
}
