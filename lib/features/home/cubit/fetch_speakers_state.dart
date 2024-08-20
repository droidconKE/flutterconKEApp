part of 'fetch_speakers_cubit.dart';

@freezed
class FetchSpeakersState with _$FetchSpeakersState {
  const factory FetchSpeakersState.initial() = _Initial;
  const factory FetchSpeakersState.loading() = _Loading;
  const factory FetchSpeakersState.loaded({
    required List<LocalSpeaker> speakers,
    required int extras,
  }) = _Loaded;
  const factory FetchSpeakersState.error(String message) = _Error;
}
