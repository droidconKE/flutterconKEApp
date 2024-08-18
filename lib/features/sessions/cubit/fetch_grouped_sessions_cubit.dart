import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' as collection;
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/session.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:fluttercon/common/repository/local_database_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'fetch_grouped_sessions_cubit.freezed.dart';
part 'fetch_grouped_sessions_state.dart';

class FetchGroupedSessionsCubit extends Cubit<FetchGroupedSessionsState> {
  FetchGroupedSessionsCubit({
    required ApiRepository apiRepository,
    required LocalDatabaseRepository localDatabaseRepository,
  }) : super(const FetchGroupedSessionsState.initial()) {
    _apiRepository = apiRepository;
    _localDatabaseRepository = localDatabaseRepository;
  }

  late ApiRepository _apiRepository;
  late LocalDatabaseRepository _localDatabaseRepository;

  Future<void> fetchGroupedSessions({
    BookmarkStatus? bookmarkStatus,
    String? sessionLevel,
    String? sessionType,
    bool forceRefresh = false,
  }) async {
    emit(const FetchGroupedSessionsState.loading());

    try {
      final hasSessions = _localDatabaseRepository.hasSessions();
      if (hasSessions && !forceRefresh) {
        final localSessions = await _localDatabaseRepository.fetchSessions(
          sessionLevel: sessionLevel,
          sessionType: sessionType,
          bookmarkStatus: bookmarkStatus,
        );

        final groupedEntries = collection.groupBy<LocalSession, String>(
          localSessions,
          (LocalSession entry) => DateFormat.yMd().format(entry.startDateTime),
        );

        emit(FetchGroupedSessionsState.loaded(groupedSessions: groupedEntries));
        return;
      }

      if (!hasSessions || forceRefresh) {
        final sessions = await _apiRepository.fetchSessions();
        await _localDatabaseRepository.persistSessions(sessions: sessions);
        final localSessions = await _localDatabaseRepository.fetchSessions(
          sessionLevel: sessionLevel,
          sessionType: sessionType,
          bookmarkStatus: bookmarkStatus,
        );

        final groupedEntries = collection.groupBy<LocalSession, String>(
          localSessions,
          (LocalSession entry) => DateFormat.yMd().format(entry.startDateTime),
        );

        emit(FetchGroupedSessionsState.loaded(groupedSessions: groupedEntries));
        return;
      }
    } catch (e) {
      emit(FetchGroupedSessionsState.error(e.toString()));
    }
  }
}
