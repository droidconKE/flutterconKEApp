part of 'google_sign_in_cubit.dart';

@freezed
class GoogleSignInState with _$GoogleSignInState {
  const factory GoogleSignInState.initial() = _Initial;
  const factory GoogleSignInState.loading() = _Loading;
  const factory GoogleSignInState.loaded({
    required String token,
  }) = _Loaded;
  const factory GoogleSignInState.error({
    required String message,
  }) = _Error;
}
