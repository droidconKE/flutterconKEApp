import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/speaker.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_speakers_cubit.freezed.dart';
part 'fetch_speakers_state.dart';

class FetchSpeakersCubit extends Cubit<FetchSpeakersState> {
  FetchSpeakersCubit({
    required ApiRepository apiRepository,
  }) : super(const FetchSpeakersState.initial()) {
    _apiRepository = apiRepository;
  }

  late ApiRepository _apiRepository;

  Future<void> fetchSpeakers() async {
    emit(const FetchSpeakersState.loading());
    try {
      final speakers = await _apiRepository.fetchSpeakers();
      emit(
        FetchSpeakersState.loaded(
          speakers: speakers,
          extras: speakers.length - 5,
        ),
      );
    } on Failure catch (e) {
      emit(FetchSpeakersState.error(e.message));
    } catch (e) {
      emit(FetchSpeakersState.error(e.toString()));
    }
  }
}
