part of 'fetch_speakers_cubit.dart';

@freezed
class FetchSpeakersState with _$FetchSpeakersState {
  const factory FetchSpeakersState.initial() = _Initial;
  const factory FetchSpeakersState.loading() = _Loading;
  const factory FetchSpeakersState.loaded(List<Speaker> speakers) = _Loaded;
  const factory FetchSpeakersState.error(String message) = _Error;
}
