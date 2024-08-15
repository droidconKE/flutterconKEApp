import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' as collection;
import 'package:fluttercon/common/data/models/session.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'fetch_grouped_sessions_cubit.freezed.dart';
part 'fetch_grouped_sessions_state.dart';

class FetchGroupedSessionsCubit extends Cubit<FetchGroupedSessionsState> {
  FetchGroupedSessionsCubit({
    required ApiRepository apiRepository,
  }) : super(const FetchGroupedSessionsState.initial()) {
    _apiRepository = apiRepository;
  }

  late ApiRepository _apiRepository;

  Future<void> fetchGroupedSessions() async {
    emit(const FetchGroupedSessionsState.loading());

    try {
      final sessions =
          await _apiRepository.fetchSessions(event: 'droidconke-2022-281');

      final groupedEntries = collection.groupBy<Session, String>(
        sessions,
        (Session entry) => DateFormat.yMd().format(entry.startDateTime),
      );

      emit(FetchGroupedSessionsState.loaded(groupedSessions: groupedEntries));
    } catch (e) {
      emit(FetchGroupedSessionsState.error(e.toString()));
    }
  }
}
