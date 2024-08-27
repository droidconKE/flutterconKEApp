import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_dto.freezed.dart';
part 'feedback_dto.g.dart';

@freezed
class FeedbackDTO with _$FeedbackDTO {
  factory FeedbackDTO({
    required String feedback,
    required int rating,
    String? sessionSlug,
  }) = _FeedbackDTO;

  factory FeedbackDTO.fromJson(Map<String, dynamic> json) =>
      _$FeedbackDTOFromJson(json);
}
