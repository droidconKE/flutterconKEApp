import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/feed.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_cubit.freezed.dart';
part 'feed_state.dart';

class FetchFeedCubit extends Cubit<FetchFeedState> {
  FetchFeedCubit({
    required ApiRepository apiRepository,
  }) : super(const FetchFeedState.initial()) {
    _apiRepository = apiRepository;
  }

  late ApiRepository _apiRepository;

  Future<void> fetchFeeds() async {
    emit(const FetchFeedState.loading());
    try {
      final feeds = await _apiRepository.fetchFeeds(
        event: 'droidconke-2022-281',
      );
      emit(FetchFeedState.loaded(fetchedFeed: feeds));
    } on Failure catch (e) {
      emit(FetchFeedState.error(e.message));
    } catch (e) {
      emit(FetchFeedState.error(e.toString()));
    }
  }
}
