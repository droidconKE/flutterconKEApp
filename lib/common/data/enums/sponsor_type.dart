import 'package:freezed_annotation/freezed_annotation.dart';

enum SponsorType {
  @JsonValue('platinum')
  platinum,
  @JsonValue('swag')
  swag,
  @JsonValue('startup')
  startup,
  @JsonValue('venue')
  venue,
  @JsonValue('bronze')
  bronze,
  @JsonValue('gold')
  gold;
}
