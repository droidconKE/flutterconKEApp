import 'package:freezed_annotation/freezed_annotation.dart';

part 'organising_team.g.dart';
part 'organising_team.freezed.dart';

@freezed
class OrganisingTeam with _$OrganisingTeam {
  factory OrganisingTeam({
    required int id,
    required String photo,
    required String name,
    required String tagline,
  }) = _OrganisingTeam;

  factory OrganisingTeam.fromJson(Map<String, Object?> json) =>
      _$OrganisingTeamFromJson(json);
}

@freezed
class OrganisingTeamResponse with _$OrganisingTeamResponse {
  const factory OrganisingTeamResponse({
    required List<OrganisingTeam> data,
  }) = _OrganisingTeamResponse;

  factory OrganisingTeamResponse.fromJson(Map<String, Object?> json) =>
      _$OrganisingTeamResponseFromJson(json);
}
