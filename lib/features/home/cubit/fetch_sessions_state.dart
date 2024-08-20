part of 'fetch_sessions_cubit.dart';

@freezed
class FetchSessionsState with _$FetchSessionsState {
  const factory FetchSessionsState.initial() = _Initial;
  const factory FetchSessionsState.loading() = _Loading;
  const factory FetchSessionsState.loaded({
    required List<LocalSession> sessions,
    required int extras,
  }) = _Loaded;
  const factory FetchSessionsState.error(String message) = _Error;
}
