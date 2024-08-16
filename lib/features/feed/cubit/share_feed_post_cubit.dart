import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/feed.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:fluttercon/features/feed/cubit/platform.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_feed_post_state.dart';
part 'share_feed_post_cubit.freezed.dart';

class ShareFeedPostCubit extends Cubit<ShareFeedPostState> {
  ShareFeedPostCubit() : super(const ShareFeedPostState.initial());

  final AppinioSocialShare appinioSocialShare = AppinioSocialShare();

  Future<void> sharePost(Feed feed, Platform platform) async {
    emit(const ShareFeedPostState.loading());

    try {
      final message = '${feed.body}\n\nhttps://fluttercon.dev';
      String? filePath;

      if (feed.image != null) {
        final files = await Misc.downloadFiles([feed.image!]);
        if (files.isNotEmpty) {
          filePath = files.first.path;
        }
      }

      final installedApps = await appinioSocialShare.getInstalledApps();

      switch (platform) {
        case Platform.telegram:
          if (installedApps['telegram'] ?? false) {
            await _shareToTelegram(message, filePath);
          } else {
            emit(const ShareFeedPostState.error('Telegram is not installed.'));
          }
        case Platform.whatsapp:
          if (installedApps['whatsapp'] ?? false) {
            await _shareToWhatsApp(message, filePath);
          } else {
            emit(const ShareFeedPostState.error('WhatsApp is not installed.'));
          }
        case Platform.twitter:
          if (installedApps['twitter'] ?? false) {
            await _shareToTwitter(message, filePath);
          } else {
            emit(const ShareFeedPostState.error('Twitter is not installed.'));
          }
        case Platform.facebook:
          if (installedApps['facebook'] ?? false) {
            if (filePath == null) {
              emit(
                const ShareFeedPostState.error(
                  'Failed to share post. Kindly share a post with an image.',
                ),
              );
            } else {
              await _shareToFacebook(message, filePath);
            }
          } else {
            emit(const ShareFeedPostState.error('Facebook is not installed.'));
          }
      }

      emit(const ShareFeedPostState.loaded());
    } catch (e) {
      emit(ShareFeedPostState.error('Failed to share post: $e'));
    }
  }

  Future<void> _shareToTelegram(String message, String? filePath) async {
    try {
      await appinioSocialShare.android.shareToTelegram(message, filePath);
    } catch (e) {
      throw Exception('Error sharing to Telegram: $e');
    }
  }

  Future<void> _shareToWhatsApp(String message, String? filePath) async {
    try {
      await appinioSocialShare.android.shareToWhatsapp(message, filePath);
    } catch (e) {
      throw Exception('Error sharing to WhatsApp: $e');
    }
  }

  Future<void> _shareToFacebook(String message, String filePath) async {
    try {
      await appinioSocialShare.android.shareToFacebook(message, [filePath]);
    } catch (e) {
      throw Exception('Error sharing to Facebook: $e');
    }
  }

  Future<void> _shareToTwitter(String message, String? filePath) async {
    try {
      await appinioSocialShare.android.shareToTwitter(message, filePath);
    } catch (e) {
      throw Exception('Error sharing to Twitter: $e');
    }
  }
}
