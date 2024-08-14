import 'package:freezed_annotation/freezed_annotation.dart';

part 'sponsor.freezed.dart';
part 'sponsor.g.dart';

@freezed
class Sponsor with _$Sponsor {
  factory Sponsor(
    String name,
    String tagline,
    String link,
    @JsonKey(name: 'sponsor_type') String sponsorType,
    String logo,
    @JsonKey(name: 'created_at') String createdAt,
  ) = _Sponsor;

  factory Sponsor.fromJson(Map<String, dynamic> json) =>
      _$SponsorFromJson(json);
}

@freezed
class SponsorResponse with _$SponsorResponse {
  factory SponsorResponse(
    List<Sponsor> data,
  ) = _SponsorResponse;

  factory SponsorResponse.fromJson(Map<String, dynamic> json) =>
      _$SponsorResponseFromJson(json);
}
