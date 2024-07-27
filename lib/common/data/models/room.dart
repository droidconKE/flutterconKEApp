import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
class Room with _$Room {
  factory Room({
    required int id,
    required String title,
  }) = _Room;

  factory Room.fromJson(Map<String, Object?> json) => _$RoomFromJson(json);
}

@freezed
class RoomResponse with _$RoomResponse {
  const factory RoomResponse({
    required List<Room> data,
  }) = _RoomResponse;

  factory RoomResponse.fromJson(Map<String, Object?> json) =>
      _$RoomResponseFromJson(json);
}
