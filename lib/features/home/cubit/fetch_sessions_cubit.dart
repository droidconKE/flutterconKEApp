import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_sessions_state.dart';
part 'fetch_sessions_cubit.freezed.dart';

class FetchSessionsCubit extends Cubit<FetchSessionsState> {
  FetchSessionsCubit({
    required ApiRepository apiRepository,
  }) : super(const FetchSessionsState.initial()) {
    _apiRepository = apiRepository;
  }

  late ApiRepository _apiRepository;

  Future<void> fetchSessions() async {
    emit(const FetchSessionsState.loading());

    try {
      final sessions =
          await _apiRepository.fetchSessions(event: 'droidconke-2022-281');
      emit(
        FetchSessionsState.loaded(
          sessions: sessions.data,
          extras:
              sessions.meta.paginator.count - sessions.meta.paginator.perPage,
        ),
      );
    } catch (e) {
      emit(FetchSessionsState.error(e.toString()));
    }
  }
}
