import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/enums/bookmark_status.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:fluttercon/common/utils/notification_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_session_state.dart';
part 'bookmark_session_cubit.freezed.dart';

class BookmarkSessionCubit extends Cubit<BookmarkSessionState> {
  BookmarkSessionCubit({
    required ApiRepository apiRepository,
    required DBRepository dBRepository,
    required NotificationService notificationService,
  }) : super(const BookmarkSessionState.initial()) {
    _apiRepository = apiRepository;
    _dBRepository = dBRepository;
    _notificationService = notificationService;
  }

  late ApiRepository _apiRepository;
  late DBRepository _dBRepository;
  late NotificationService _notificationService;

  Future<void> bookmarkSession({
    required int sessionId,
    int? index,
  }) async {
    try {
      emit(BookmarkSessionState.loading(index: index));
      final message = await _apiRepository.bookmarkSession(sessionId);

      final bookmarkStatus = BookmarkStatus.fromString(message);

      await _dBRepository.updateSession(
        sessionId: sessionId,
        bookmarkStatus: bookmarkStatus == BookmarkStatus.bookmarked,
      );

      if (bookmarkStatus == BookmarkStatus.bookmarked) {
        final session = await _dBRepository.getSession(sessionId);
        await _notificationService.createScheduledNotification(
          session: session!,
          channelKey: 'session_channel',
        );
      }
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
