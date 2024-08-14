import 'package:fluttercon/common/data/models/meta.dart';
import 'package:fluttercon/common/data/models/speaker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  factory Session(
    String title,
    String description,
    String slug,
    @JsonKey(name: 'session_image') String sessionImage,
    @JsonKey(name: 'session_category') String sessionCategory,
    @JsonKey(name: 'session_format') String sessionFormat,
    @JsonKey(name: 'session_level') String sessionLevel, {
    @JsonKey(name: 'is_keynote') required bool isKeynote,
    @Default([]) List<Speaker> speakers,
  }) = _Session;

  factory Session.fromJson(Map<String, Object?> json) =>
      _$SessionFromJson(json);
}

@freezed
class SessionResponse with _$SessionResponse {
  const factory SessionResponse({
    required List<Session> data,
    required Meta meta,
  }) = _SessionResponse;

  factory SessionResponse.fromJson(Map<String, Object?> json) =>
      _$SessionResponseFromJson(json);
}
