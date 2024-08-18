import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/local/local_feed.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_cubit.freezed.dart';
part 'feed_state.dart';

class FetchFeedCubit extends Cubit<FetchFeedState> {
  FetchFeedCubit({
    required ApiRepository apiRepository,
    required DBRepository dBRepository,
  }) : super(const FetchFeedState.initial()) {
    _apiRepository = apiRepository;
    _dBRepository = dBRepository;
  }

  late ApiRepository _apiRepository;
  late DBRepository _dBRepository;

  Future<void> fetchFeeds({
    bool forceRefresh = false,
  }) async {
    emit(const FetchFeedState.loading());
    try {
      // Fetch feed entries from local database
      final feedEntries = await _dBRepository.fetchLocalFeedEntries();
      if (feedEntries.isNotEmpty && !forceRefresh) {
        emit(FetchFeedState.loaded(fetchedFeed: feedEntries));
        return;
      }

      // Fetch feed entries from API if local database is empty and persist them
      if (feedEntries.isEmpty || forceRefresh) {
        final feeds = await _apiRepository.fetchFeeds();
        await _dBRepository.persistLocalFeedEntries(entries: feeds);
        final feedEntries = await _dBRepository.fetchLocalFeedEntries();
        emit(FetchFeedState.loaded(fetchedFeed: feedEntries));
        return;
      }
    } on Failure catch (e) {
      emit(FetchFeedState.error(e.message));
    } catch (e) {
      emit(FetchFeedState.error(e.toString()));
    }
  }
}
