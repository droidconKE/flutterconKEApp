import 'package:freezed_annotation/freezed_annotation.dart';

enum OrganiserType {
  @JsonValue('individual')
  individual,
  @JsonValue('company')
  company;
}
