import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/repository/auth_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_out_state.dart';
part 'log_out_cubit.freezed.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit({
    required AuthRepository authRepository,
    required HiveRepository hiveRepository,
    required DBRepository dbRepository,
  }) : super(const LogOutState.initial()) {
    _hiveRepository = hiveRepository;
    _authRepository = authRepository;
    _dbRepository = dbRepository;
  }

  late AuthRepository _authRepository;
  late HiveRepository _hiveRepository;
  late DBRepository _dbRepository;

  Future<void> logOut() async {
    emit(const LogOutState.loading());
    try {
      await _dbRepository.clearAllTables();
      await _authRepository.logOut();
      _hiveRepository.clearPrefs();
      emit(const LogOutState.loaded());
    } catch (e) {
      emit(const LogOutState.loaded());
    }
  }
}
