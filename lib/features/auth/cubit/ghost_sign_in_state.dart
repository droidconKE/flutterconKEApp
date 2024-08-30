part of 'ghost_sign_in_cubit.dart';

@freezed
class GhostSignInState with _$GhostSignInState {
  const factory GhostSignInState.initial() = _Initial;
  const factory GhostSignInState.loading() = _Loading;
  const factory GhostSignInState.loaded() = _Loaded;
  const factory GhostSignInState.error(String message) = _Error;
}
