import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

@freezed
class Paginator with _$Paginator {
  factory Paginator({
    required int count,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'current_page') int? currentPage,
    @JsonKey(name: 'next_page') String? nextPage,
    @JsonKey(name: 'has_more_pages') bool? hasMorePages,
    @JsonKey(name: 'next_page_url') String? nextPageUrl,
    @JsonKey(name: 'previous_page_url') String? previousPageUrl,
  }) = _Paginator;

  factory Paginator.fromJson(Map<String, dynamic> json) =>
      _$PaginatorFromJson(json);
}

@freezed
class Meta with _$Meta {
  factory Meta({
    required Paginator paginator,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}
