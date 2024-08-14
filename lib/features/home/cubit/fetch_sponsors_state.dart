part of 'fetch_sponsors_cubit.dart';

@freezed
class FetchSponsorsState with _$FetchSponsorsState {
  const factory FetchSponsorsState.initial() = _Initial;
  const factory FetchSponsorsState.loading() = _Loading;
  const factory FetchSponsorsState.loaded(List<Sponsor> sponsors) = _Loaded;
  const factory FetchSponsorsState.error(String message) = _Error;
}
