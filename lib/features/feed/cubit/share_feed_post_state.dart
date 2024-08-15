part of 'share_feed_post_cubit.dart';

@freezed
class ShareFeedPostState with _$ShareFeedPostState {
  const factory ShareFeedPostState.initial() = _Initial;
  const factory ShareFeedPostState.loading() = _Loading;
  const factory ShareFeedPostState.loaded() = _Loaded;
  const factory ShareFeedPostState.error(String message) = _Error;
}
