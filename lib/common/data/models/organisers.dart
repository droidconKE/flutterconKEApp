import 'package:freezed_annotation/freezed_annotation.dart';

part 'organisers.g.dart';
part 'organisers.freezed.dart';

@freezed
class Organiser with _$Organiser {
  factory Organiser({
    required int id,
    required String logo,
    required String name,
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
