import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/enums/social_platform.dart';
import 'package:fluttercon/common/repository/share_repository.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

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
      Logger().i(installedApps);

      switch (platform) {
        case SocialPlatform.telegram:
          if (!installedApps.containsKey('telegram') ||
              installedApps['telegram'] == false) {
            emit(const ShareFeedPostState.error('Telegram is not installed.'));
            return;
          }
          try {
            final result =
                await _shareRepository.shareToTelegram(message, filePath);
            Logger().d(result);
            emit(const ShareFeedPostState.loaded());
          } catch (e) {
            return;
          }

        case SocialPlatform.whatsapp:
          if (!installedApps.containsKey('whatsapp') ||
              installedApps['whatsapp'] == false) {
            emit(const ShareFeedPostState.error('WhatsApp is not installed.'));
            return;
          }
          try {
            final result =
                await _shareRepository.shareToWhatsApp(message, filePath);
            Logger().d(result);
            emit(const ShareFeedPostState.loaded());
          } catch (e) {
            emit(
              const ShareFeedPostState.error('WhatsApp is not installed.'),
            );
            return;
          }

        case SocialPlatform.twitter:
          if (!installedApps.containsKey('twitter') ||
              installedApps['twitter'] == false) {
            emit(const ShareFeedPostState.error('Twitter is not installed.'));
            return;
          }
          try {
            final result =
                await _shareRepository.shareToTwitter(message, filePath);
            Logger().d(result);
            emit(const ShareFeedPostState.loaded());
          } catch (e) {
            emit(const ShareFeedPostState.error('Twitter is not installed.'));
            return;
          }
      }
    } catch (e) {
      emit(ShareFeedPostState.error('Failed to share post: $e'));
    }
  }
}
