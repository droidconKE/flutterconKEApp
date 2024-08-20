part of 'fetch_grouped_sessions_cubit.dart';

@freezed
class FetchGroupedSessionsState with _$FetchGroupedSessionsState {
  const factory FetchGroupedSessionsState.initial() = _Initial;
  const factory FetchGroupedSessionsState.loading() = _Loading;
  const factory FetchGroupedSessionsState.loaded({
    required Map<String, List<LocalSession>> groupedSessions,
  }) = _Loaded;
  const factory FetchGroupedSessionsState.error(String message) = _Error;
}
