import 'package:freezed_annotation/freezed_annotation.dart';

part 'individual_organiser.freezed.dart';
part 'individual_organiser.g.dart';

@freezed
class IndividualOrganiser with _$IndividualOrganiser {
  factory IndividualOrganiser(
    String name,
    String tagline,
    String link,
    String type,
    String bio,
    String designation,
    String photo,
    @JsonKey(name: 'twitter_handle') String twitterHandle,
  ) = _IndividualOrganiser;

  factory IndividualOrganiser.fromJson(Map<String, dynamic> json) =>
      _$IndividualOrganiserFromJson(json);
}

@freezed
class IndividualOrganiserResponse with _$IndividualOrganiserResponse {
  const factory IndividualOrganiserResponse({
    required List<IndividualOrganiser> data,
  }) = _IndividualOrganiserResponse;

  factory IndividualOrganiserResponse.fromJson(Map<String, dynamic> json) =>
      _$IndividualOrganiserResponseFromJson(json);
}
