part of 'fetch_organising_team_cubit.dart';

@freezed
class FetchOrganisingTeamState with _$FetchOrganisingTeamState {
  const factory FetchOrganisingTeamState.initial() = _Initial;
  const factory FetchOrganisingTeamState.loading() = _Loading;
  const factory FetchOrganisingTeamState.loaded({
    required List<OrganisingTeam> organisers,
  }) = _Loaded;
  const factory FetchOrganisingTeamState.error(String message) = _Error;
}
