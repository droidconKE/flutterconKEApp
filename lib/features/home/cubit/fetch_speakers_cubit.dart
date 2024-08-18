import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/local_database_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_speakers_cubit.freezed.dart';
part 'fetch_speakers_state.dart';

class FetchSpeakersCubit extends Cubit<FetchSpeakersState> {
  FetchSpeakersCubit({
    required ApiRepository apiRepository,
    required LocalDatabaseRepository localDatabaseRepository,
  }) : super(const FetchSpeakersState.initial()) {
    _apiRepository = apiRepository;
    _localDatabaseRepository = localDatabaseRepository;
  }

  late ApiRepository _apiRepository;
  late LocalDatabaseRepository _localDatabaseRepository;

  Future<void> fetchSpeakers({
    bool forceRefresh = false,
  }) async {
    emit(const FetchSpeakersState.loading());
    try {
      final localSpeakers = await _localDatabaseRepository.fetchLocalSpeakers();
      if (localSpeakers.isNotEmpty && !forceRefresh) {
        emit(
          FetchSpeakersState.loaded(
            speakers: localSpeakers,
            extras: localSpeakers.length - 5,
          ),
        );
        return;
      }

      if (localSpeakers.isEmpty || forceRefresh) {
        final speakers = await _apiRepository.fetchSpeakers();
        await _localDatabaseRepository.persistLocalSpeakers(speakers: speakers);
        final localSpeakers =
            await _localDatabaseRepository.fetchLocalSpeakers();
        emit(
          FetchSpeakersState.loaded(
            speakers: localSpeakers,
            extras: localSpeakers.length - 5,
          ),
        );
        return;
      }
    } on Failure catch (e) {
      emit(FetchSpeakersState.error(e.message));
    } catch (e) {
      emit(FetchSpeakersState.error(e.toString()));
    }
  }
}
