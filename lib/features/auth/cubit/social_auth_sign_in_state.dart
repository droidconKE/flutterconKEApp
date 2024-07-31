part of 'social_auth_sign_in_cubit.dart';

@freezed
class SocialAuthSignInState with _$SocialAuthSignInState {
  const factory SocialAuthSignInState.initial() = _Initial;
  const factory SocialAuthSignInState.loading() = _Loading;
  const factory SocialAuthSignInState.loaded() = _Loaded;
  const factory SocialAuthSignInState.error({
    required String message,
  }) = _Error;
}
