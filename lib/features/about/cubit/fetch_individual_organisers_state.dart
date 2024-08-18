part of 'fetch_individual_organisers_cubit.dart';

@freezed
class FetchIndividualOrganisersState with _$FetchIndividualOrganisersState {
  const factory FetchIndividualOrganisersState.initial() = _Initial;
  const factory FetchIndividualOrganisersState.loading() = _Loading;
  const factory FetchIndividualOrganisersState.loaded({
    required List<LocalIndividualOrganiser> individualOrganisers,
  }) = _Loaded;
  const factory FetchIndividualOrganisersState.error(String message) = _Error;
}
