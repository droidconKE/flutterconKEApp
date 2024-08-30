import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/repository/auth_repository.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost_sign_in_state.dart';
part 'ghost_sign_in_cubit.freezed.dart';

class GhostSignInCubit extends Cubit<GhostSignInState> {
  GhostSignInCubit({
    required AuthRepository authRepository,
    required HiveRepository hiveRepository,
  }) : super(const GhostSignInState.initial()) {
    _authRepository = authRepository;
    _hiveRepository = hiveRepository;
  }

  late AuthRepository _authRepository;
  late HiveRepository _hiveRepository;

  Future<void> signIn() async {
    emit(const GhostSignInState.loading());
    try {
      final authResult = await _authRepository.ghostSignIn();
      _hiveRepository
        ..persistToken(authResult.token)
        ..persistUser(authResult.user);

      emit(const GhostSignInState.loaded());
    } catch (e) {
      emit(GhostSignInState.error(e.toString()));
    }
  }
}
