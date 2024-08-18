part of 'feed_cubit.dart';

@freezed
class FetchFeedState with _$FetchFeedState {
  const factory FetchFeedState.initial() = _Initial;
  const factory FetchFeedState.loading() = _Loading;
  const factory FetchFeedState.loaded({
    required List<LocalFeedEntry> fetchedFeed,
  }) = _Loaded;
  const factory FetchFeedState.error(String message) = _Error;
}
