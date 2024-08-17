import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/enums/social_platform.dart';
import 'package:fluttercon/common/repository/share_repository.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_feed_post_state.dart';
part 'share_feed_post_cubit.freezed.dart';

class ShareFeedPostCubit extends Cubit<ShareFeedPostState> {
  ShareFeedPostCubit({
    required ShareRepository shareRepository,
  }) : super(const ShareFeedPostState.initial()) {
    _shareRepository = shareRepository;
  }

  late ShareRepository _shareRepository;

  Future<void> sharePost({
    required String body,
    required SocialPlatform platform,
    String? fileUrl,
  }) async {
    emit(const ShareFeedPostState.loading());

    try {
      final message = '$body\n\nhttps://fluttercon.dev';
      String? filePath;

      if (fileUrl != null) {
        final files = await Misc.downloadFiles([fileUrl]);
        if (files.isNotEmpty) {
          filePath = files.first.path;
        }
      }

      final installedApps = await _shareRepository.getInstalledApps();

      switch (platform) {
        case SocialPlatform.telegram:
          if (installedApps.containsKey('telegram')) {
            await _shareRepository.shareToTelegram(message, filePath);
          } else {
            emit(const ShareFeedPostState.error('Telegram is not installed.'));
          }
        case SocialPlatform.whatsapp:
          if (installedApps.containsKey('whatsapp')) {
            await _shareRepository.shareToWhatsApp(message, filePath);
          } else {
            emit(const ShareFeedPostState.error('WhatsApp is not installed.'));
          }
        case SocialPlatform.twitter:
          if (installedApps.containsKey('twitter')) {
            await _shareRepository.shareToTwitter(message, filePath);
          } else {
            emit(const ShareFeedPostState.error('Twitter is not installed.'));
          }
        case SocialPlatform.facebook:
          if (installedApps.containsKey('facebook')) {
            if (filePath == null) {
              emit(
                const ShareFeedPostState.error(
                  'Failed to share post. Kindly share a post with an image.',
                ),
              );
            } else {
              await _shareRepository.shareToFacebook(message, filePath);
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
}
