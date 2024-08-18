import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_speakers_cubit.freezed.dart';
part 'fetch_speakers_state.dart';

class FetchSpeakersCubit extends Cubit<FetchSpeakersState> {
  FetchSpeakersCubit({
    required ApiRepository apiRepository,
    required DBRepository dBRepository,
  }) : super(const FetchSpeakersState.initial()) {
    _apiRepository = apiRepository;
    _dBRepository = dBRepository;
  }

  late ApiRepository _apiRepository;
  late DBRepository _dBRepository;

  Future<void> fetchSpeakers({
    bool forceRefresh = false,
  }) async {
    emit(const FetchSpeakersState.loading());
    try {
      final localSpeakers = await _dBRepository.fetchSpeakers();
      if (localSpeakers.isNotEmpty && !forceRefresh) {
        emit(
          FetchSpeakersState.loaded(
            speakers: localSpeakers,
            extras: localSpeakers.length - 5,
          ),
        );
        await _networkFetch();
        return;
      }

      if (localSpeakers.isEmpty || forceRefresh) {
        await _networkFetch();
        final localSpeakers = await _dBRepository.fetchSpeakers();
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

  Future<void> _networkFetch() async {
    final speakers = await _apiRepository.fetchSpeakers();
    await _dBRepository.persistSpeakers(speakers: speakers);
  }
}
