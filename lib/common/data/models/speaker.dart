import 'package:freezed_annotation/freezed_annotation.dart';

part 'speaker.freezed.dart';
part 'speaker.g.dart';

@freezed
class Speaker with _$Speaker {
  const factory Speaker(
      {required String name,
      String? tagline,
      required String biography,
      required String avatar,
      String? twitter,
      String? facebook,
      String? linkedin,
      String? instagram,
      String? blog,
      // ignore: invalid_annotation_target
      @JsonKey(name: 'company_website') String? companyWebsite}) = _Speaker;

  factory Speaker.fromJson(Map<String, Object?> json) =>
      _$SpeakerFromJson(json);
}
