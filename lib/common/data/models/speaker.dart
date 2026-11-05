import 'package:freezed_annotation/freezed_annotation.dart';

part 'speaker.freezed.dart';
part 'speaker.g.dart';

@freezed
abstract class Speaker with _$Speaker {
  const factory Speaker({
    required String name,
    // The API returns `null` for speakers who haven't filled these in; a
    // single null used to fail parsing of the whole speakers list.
    @Default('') String biography,
    @Default('') String avatar,
    String? tagline,
    String? twitter,
    String? facebook,
    String? linkedin,
    String? instagram,
    String? blog,
    @JsonKey(name: 'company_website') String? companyWebsite,
  }) = _Speaker;

  factory Speaker.fromJson(Map<String, Object?> json) =>
      _$SpeakerFromJson(json);
}

@freezed
abstract class SpeakerResponse with _$SpeakerResponse {
  const factory SpeakerResponse({required List<Speaker> data}) =
      _SpeakerResponse;

  factory SpeakerResponse.fromJson(Map<String, Object?> json) =>
      _$SpeakerResponseFromJson(json);
}
