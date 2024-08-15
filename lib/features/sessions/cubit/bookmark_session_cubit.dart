import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/hive_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_session_state.dart';
part 'bookmark_session_cubit.freezed.dart';

class BookmarkSessionCubit extends Cubit<BookmarkSessionState> {
  BookmarkSessionCubit({
    required ApiRepository apiRepository,
    required HiveRepository hiveRepository,
  }) : super(const BookmarkSessionState.initial()) {
    _apiRepository = apiRepository;
    _hiveRepository = hiveRepository;
  }

  late ApiRepository _apiRepository;
  late HiveRepository _hiveRepository;

  Future<void> bookmarkSession({
    required int sessionId,
    int? index,
  }) async {
    try {
      emit(BookmarkSessionState.loading(index: index));
      final message = await _apiRepository.bookmarkSession(sessionId);

      final bookmarkStatus = BookmarkStatus.fromString(message);

      _hiveRepository.updateSession(
        sessionId: sessionId,
        bookmarkStatus: bookmarkStatus == BookmarkStatus.bookmarked,
      );

      emit(
        BookmarkSessionState.loaded(
          message: message,
          status: bookmarkStatus,
        ),
      );
    } catch (e) {
      emit(BookmarkSessionState.error(e.toString()));
    }
  }
}
