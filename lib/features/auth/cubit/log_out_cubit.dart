import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/repository/auth_repository.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_out_state.dart';
part 'log_out_cubit.freezed.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit({
    required AuthRepository authRepository,
    required HiveRepository hiveRepository,
  }) : super(const LogOutState.initial()) {
    _hiveRepository = hiveRepository;
    _authRepository = authRepository;
  }

  late AuthRepository _authRepository;
  late HiveRepository _hiveRepository;

  Future<void> logOut() async {
    emit(const LogOutState.loading());
    try {
      _hiveRepository.clearPrefs();
      await _authRepository.logOut();
      emit(const LogOutState.loaded());
    } catch (e) {
      emit(const LogOutState.loaded());
    }
  }
}
