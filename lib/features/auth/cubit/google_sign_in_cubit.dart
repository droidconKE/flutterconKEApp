import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/repository/auth_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_sign_in_state.dart';
part 'google_sign_in_cubit.freezed.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit({
    required AuthRepository authRepository,
  }) : super(const GoogleSignInState.initial()) {
    _authRepository = authRepository;
  }

  late AuthRepository _authRepository;

  Future<void> signInWithGoogle() async {
    emit(const GoogleSignInState.loading());
    try {
      final token = await _authRepository.signInWithGoogle();
      emit(GoogleSignInState.loaded(token: token));
    } catch (e) {
      emit(GoogleSignInState.error(message: e.toString()));
    }
  }
}
