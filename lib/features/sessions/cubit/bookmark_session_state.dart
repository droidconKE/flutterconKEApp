part of 'bookmark_session_cubit.dart';

@freezed
class BookmarkSessionState with _$BookmarkSessionState {
  const factory BookmarkSessionState.initial() = _Initial;
  const factory BookmarkSessionState.loading({
    int? index,
  }) = _Loading;
  const factory BookmarkSessionState.loaded({
    required String message,
    BookmarkStatus? status,
  }) = _Loaded;
  const factory BookmarkSessionState.error(String message) = _Error;
}
