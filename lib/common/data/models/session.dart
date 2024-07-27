import 'package:freezed_annotation/freezed_annotation.dart';

import 'speaker.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  factory Session({
    required String title,
    required String description,
    required String slug,
    @JsonKey(name: 'session_format') required String sessionFormat,
    @JsonKey(name: 'session_level') required String sessionLevel,
    @Default([]) List<Speaker> speakers,
  }) = _Session;

  factory Session.fromJson(Map<String, Object?> json) =>
      _$SessionFromJson(json);
}
