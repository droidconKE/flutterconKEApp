part of 'share_session_cubit.dart';

@freezed
class ShareSessionState with _$ShareSessionState {
  const factory ShareSessionState.initial() = _Initial;
  const factory ShareSessionState.loading() = _Loading;
  const factory ShareSessionState.loaded() = _Loaded;
  const factory ShareSessionState.error(String message) = _Error;
}
