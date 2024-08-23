import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/feedback_dto.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_feedback_state.dart';
part 'send_feedback_cubit.freezed.dart';

class SendFeedbackCubit extends Cubit<SendFeedbackState> {
  SendFeedbackCubit({
    required ApiRepository apiRepository,
  })  : _apiRepository = apiRepository,
        super(const SendFeedbackState.initial());

  final ApiRepository _apiRepository;

  Future<void> sendFeedback({
    required String feedback,
    required int rating,
    String? sessionSlug,
  }) async {
    try {
      emit(const SendFeedbackState.loading());
      final message = await _apiRepository.submitFeedback(
        feedbackDTO: FeedbackDTO(
          feedback: feedback,
          rating: rating,
          sessionSlug: sessionSlug,
        ),
      );

      emit(
        SendFeedbackState.loaded(
          feedback: message,
          rating: rating,
        ),
      );
    } catch (e) {
      emit(SendFeedbackState.error(e.toString()));
    }
  }
}
