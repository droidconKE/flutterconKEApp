import 'package:freezed_annotation/freezed_annotation.dart';

part 'organisers.g.dart';
part 'organisers.freezed.dart';

@freezed
class Organiser with _$Organiser {
  factory Organiser({
    @JsonKey(name: 'photo') required String logo,
    required String name,
    @JsonEnum() required String type,
    required String tagline,
    required String bio,
    required String designation,
  }) = _Organiser;

  factory Organiser.fromJson(Map<String, Object?> json) =>
      _$OrganiserFromJson(json);
}

@freezed
class OrganiserResponse with _$OrganiserResponse {
  const factory OrganiserResponse({
    required List<Organiser> data,
  }) = _OrganiserResponse;

  factory OrganiserResponse.fromJson(Map<String, Object?> json) =>
      _$OrganiserResponseFromJson(json);
}
