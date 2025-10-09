import 'package:fluttercon/common/data/enums/sponsor_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sponsor.freezed.dart';
part 'sponsor.g.dart';

@freezed
abstract class Sponsor with _$Sponsor {
  factory Sponsor(
    String name,
    String tagline,
    String link,
    @JsonEnum() @JsonKey(name: 'sponsor_type') SponsorType sponsorType,
    String logo,
    @JsonKey(name: 'created_at') String createdAt,
  ) = _Sponsor;

  factory Sponsor.fromJson(Map<String, dynamic> json) =>
      _$SponsorFromJson(json);
}

@freezed
abstract class SponsorResponse with _$SponsorResponse {
  factory SponsorResponse(List<Sponsor> data) = _SponsorResponse;

  factory SponsorResponse.fromJson(Map<String, dynamic> json) =>
      _$SponsorResponseFromJson(json);
}
