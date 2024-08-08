import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginator.freezed.dart';
part 'paginator.g.dart';

@freezed
class Paginator with _$Paginator {
  factory Paginator({
    required int count,
    required int per_page,
    required int current_page,
    required int? next_page,
    required bool has_more_pages,
    required String next_page_url,
    required String previous_page_url,
  }) = _Paginator;

  factory Paginator.fromJson(Map<String, Object?> json) =>
      _$PaginatorFromJson(json);
}
@freezed
class PaginatorResponse with _$PaginatorResponse {
  const factory PaginatorResponse({
    required Paginator meta,
  }) = _PaginatorResponse;

  factory PaginatorResponse.fromJson(Map<String, Object?> json) =>
      _$PaginatorResponseFromJson(json);
}
