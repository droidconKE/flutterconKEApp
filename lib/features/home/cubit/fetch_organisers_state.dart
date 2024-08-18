part of 'fetch_organisers_cubit.dart';

@freezed
class FetchOrganisersState with _$FetchOrganisersState {
  const factory FetchOrganisersState.initial() = _Initial;
  const factory FetchOrganisersState.loading() = _Loading;
  const factory FetchOrganisersState.loaded({
    required List<LocalOrganiser> organisers,
  }) = _Loaded;
  const factory FetchOrganisersState.error(String message) = _Error;
}
