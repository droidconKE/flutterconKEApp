import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed.freezed.dart';
part 'feed.g.dart';

@freezed
class Feed with _$Feed {
  factory Feed({
    required String title,
    required String body,
    required String topic,
    required String url,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default('https://via.placeholder.com/150') String image,
  }) = _Feed;

  factory Feed.fromJson(Map<String, Object?> json) => _$FeedFromJson(json);
}

@freezed
class FeedResponse with _$FeedResponse {
  const factory FeedResponse({
    required List<Feed> data,
  }) = _FeedResponse;

  factory FeedResponse.fromJson(Map<String, Object?> json) =>
      _$FeedResponseFromJson(json);
}
