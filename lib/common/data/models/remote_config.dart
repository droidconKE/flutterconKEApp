import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config.freezed.dart';
part 'remote_config.g.dart';

@freezed
class RemoteConfig with _$RemoteConfig {
  factory RemoteConfig({
    @JsonKey(name: 'app_version') required String appVersion,
    @JsonKey(name: 'is_in_review') required bool isInReview,
  }) = _RemoteConfig;

  factory RemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigFromJson(json);
}
