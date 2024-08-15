import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' as collection;
import 'package:fluttercon/common/data/models/session.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'fetch_grouped_sessions_cubit.freezed.dart';
part 'fetch_grouped_sessions_state.dart';

class FetchGroupedSessionsCubit extends Cubit<FetchGroupedSessionsState> {
  FetchGroupedSessionsCubit({
    required ApiRepository apiRepository,
    required HiveRepository hiveRepository,
  }) : super(const FetchGroupedSessionsState.initial()) {
    _apiRepository = apiRepository;
    _hiveRepository = hiveRepository;
  }

  late ApiRepository _apiRepository;
  late HiveRepository _hiveRepository;

  Future<void> fetchGroupedSessions() async {
    emit(const FetchGroupedSessionsState.loading());

    try {
      final persistedSessions = _hiveRepository.retrieveSessions();
      if (persistedSessions.isNotEmpty) {
        final groupedEntries = collection.groupBy<Session, String>(
          persistedSessions,
          (Session entry) => DateFormat.yMd().format(entry.startDateTime),
        );

        emit(FetchGroupedSessionsState.loaded(groupedSessions: groupedEntries));
        return;
      } else {
        final sessions = await _apiRepository.fetchSessions();
        _hiveRepository.persistSessions(sessions: sessions);

        final groupedEntries = collection.groupBy<Session, String>(
          sessions,
          (Session entry) => DateFormat.yMd().format(entry.startDateTime),
        );

        emit(FetchGroupedSessionsState.loaded(groupedSessions: groupedEntries));
        return;
      }
    } catch (e) {
      emit(FetchGroupedSessionsState.error(e.toString()));
    }
  }
}
