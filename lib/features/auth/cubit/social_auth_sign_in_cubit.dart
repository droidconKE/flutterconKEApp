import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/repository/auth_repository.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_auth_sign_in_state.dart';
part 'social_auth_sign_in_cubit.freezed.dart';

class SocialAuthSignInCubit extends Cubit<SocialAuthSignInState> {
  SocialAuthSignInCubit({
    required AuthRepository authRepository,
    required HiveRepository hiveRepository,
  }) : super(const SocialAuthSignInState.initial()) {
    _authRepository = authRepository;
    _hiveRepository = hiveRepository;
  }

  late AuthRepository _authRepository;
  late HiveRepository _hiveRepository;

  Future<void> socialSignIn({
    required String token,
  }) async {
    emit(const SocialAuthSignInState.loading());
    try {
      final authResult = await _authRepository.signIn(
        token: token,
      );
      _hiveRepository
        ..persistToken(authResult.token)
        ..persistUser(authResult.user);

      emit(const SocialAuthSignInState.loaded());
    } catch (e) {
      emit(SocialAuthSignInState.error(message: e.toString()));
    }
  }
}
