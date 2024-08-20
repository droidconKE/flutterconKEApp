import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_sessions_state.dart';
part 'fetch_sessions_cubit.freezed.dart';

class FetchSessionsCubit extends Cubit<FetchSessionsState> {
  FetchSessionsCubit({
    required ApiRepository apiRepository,
    required DBRepository dBRepository,
  }) : super(const FetchSessionsState.initial()) {
    _apiRepository = apiRepository;
    _databaseRepository = dBRepository;
  }

  late ApiRepository _apiRepository;
  late DBRepository _databaseRepository;

  Future<void> fetchSessions({
    bool forceRefresh = false,
  }) async {
    emit(const FetchSessionsState.loading());

    try {
      final localSessions = await _databaseRepository.fetchSessions();
      if (localSessions.isNotEmpty && !forceRefresh) {
        final filteredSessions = localSessions
            .where((session) => !session.isServiceSession)
            .toList();

        emit(
          FetchSessionsState.loaded(
            sessions: filteredSessions,
            extras: localSessions.length - 5,
          ),
        );
        await _networkFetch();
        return;
      }

      if (localSessions.isEmpty || forceRefresh) {
        await _networkFetch();

        final localSessions = await _databaseRepository.fetchSessions();
        final filteredSessions = localSessions
            .where((session) => !session.isServiceSession)
            .toList();
        emit(
          FetchSessionsState.loaded(
            sessions: filteredSessions,
            extras: localSessions.length - 5,
          ),
        );
        return;
      }
    } on Failure catch (e) {
      emit(FetchSessionsState.error(e.message));
    } catch (e) {
      emit(FetchSessionsState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final sessions = await _apiRepository.fetchSessions();
    await _databaseRepository.persistSessions(sessions: sessions);
  }
}
