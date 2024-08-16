import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
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
    int? index,
    int? rating,
  }) async {
    try {
      emit(SendFeedbackState.loading(index: index));
      final message = await _apiRepository.submitFeedback(
        feedback: feedback,
        rating: rating,
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
