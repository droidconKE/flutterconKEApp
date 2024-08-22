import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
class FlutterConUser with _$FlutterConUser {
  const factory FlutterConUser(
    String name,
    String email,
    @JsonKey(name: 'created_at') String createdAt, {
    @Default('https://via.placeholder.com/150') String avatar,
  }) = _FlutterConUser;

  factory FlutterConUser.fromJson(Map<String, Object?> json) =>
      _$FlutterConUserFromJson(json);
}

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult({
    required String token,
    required FlutterConUser user,
  }) = _AuthResult;

  factory AuthResult.fromJson(Map<String, Object?> json) =>
      _$AuthResultFromJson(json);
}
