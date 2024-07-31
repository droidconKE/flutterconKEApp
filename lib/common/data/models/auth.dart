import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
class FlutterConUser with _$FlutterConUser {
  const factory FlutterConUser(
    String name,
    String email,
    String avatar,
    @JsonKey(name: 'created_at') String createdAt,
  ) = _FlutterConUser;

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
