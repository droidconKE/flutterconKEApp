import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' as collection;
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'fetch_grouped_sessions_cubit.freezed.dart';
part 'fetch_grouped_sessions_state.dart';

class FetchGroupedSessionsCubit extends Cubit<FetchGroupedSessionsState> {
  FetchGroupedSessionsCubit({
    required ApiRepository apiRepository,
    required DBRepository dBRepository,
  }) : super(const FetchGroupedSessionsState.initial()) {
    _apiRepository = apiRepository;
    _dBRepository = dBRepository;
  }

  late ApiRepository _apiRepository;
  late DBRepository _dBRepository;

  Future<void> fetchGroupedSessions({
    BookmarkStatus? bookmarkStatus,
    String? sessionLevel,
    String? sessionType,
    bool forceRefresh = false,
  }) async {
    emit(const FetchGroupedSessionsState.loading());

    try {
      final hasSessions = _dBRepository.hasSessions();
      if (hasSessions && !forceRefresh) {
        final localSessions = await _dBRepository.fetchSessions(
          sessionLevel: sessionLevel,
          sessionType: sessionType,
          bookmarkStatus: bookmarkStatus,
        );

        final groupedEntries = collection.groupBy<LocalSession, String>(
          localSessions,
          (LocalSession entry) => DateFormat.yMd().format(entry.startDateTime),
        );

        emit(FetchGroupedSessionsState.loaded(groupedSessions: groupedEntries));
        await _networkFetch();
        return;
      }

      if (!hasSessions || forceRefresh) {
        await _networkFetch();
        final localSessions = await _dBRepository.fetchSessions(
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

  Future<void> _networkFetch() async {
    final sessions = await _apiRepository.fetchSessions();
    await _dBRepository.persistSessions(sessions: sessions);
  }
}
