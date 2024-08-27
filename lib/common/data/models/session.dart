import 'package:fluttercon/common/data/models/room.dart';
import 'package:fluttercon/common/data/models/speaker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  factory Session(
    int id,
    String title,
    String description,
    String slug,
    @JsonKey(name: 'session_category') String sessionCategory,
    @JsonKey(name: 'session_format') String sessionFormat,
    @JsonKey(name: 'start_date_time') DateTime startDateTime,
    @JsonKey(name: 'end_date_time') DateTime endDateTime,
    @JsonKey(name: 'start_time') String startTime,
    @JsonKey(name: 'end_time') String endTime,
    @JsonKey(name: 'session_level') String sessionLevel, {
    @JsonKey(name: 'is_keynote') required bool isKeynote,
    @JsonKey(name: 'is_bookmarked') required bool isBookmarked,
    @JsonKey(name: 'is_serviceSession') required bool isServiceSession,
    @Default('https://via.placeholder.com/150')
    @JsonKey(name: 'session_image')
    String sessionImage,
    @Default([]) List<Speaker> speakers,
    @Default([]) List<Room> rooms,
  }) = _Session;

  factory Session.fromJson(Map<String, Object?> json) =>
      _$SessionFromJson(json);
}

@freezed
class SessionResponse with _$SessionResponse {
  const factory SessionResponse({
    required List<Session> data,
  }) = _SessionResponse;

  factory SessionResponse.fromJson(Map<String, Object?> json) =>
      _$SessionResponseFromJson(json);
}
