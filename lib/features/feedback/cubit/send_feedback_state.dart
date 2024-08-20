part of 'send_feedback_cubit.dart';

@freezed
class SendFeedbackState with _$SendFeedbackState {
  const factory SendFeedbackState.initial() = _Initial;
  const factory SendFeedbackState.loading({
    int? index,
  }) = _Loading;
  const factory SendFeedbackState.loaded({
    required String feedback,
    int? rating,
  }) = _Loaded;
  const factory SendFeedbackState.error(String message) = _Error;
}
