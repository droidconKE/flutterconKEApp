import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/local/local_sponsor.dart';
import 'package:fluttercon/common/data/models/sponsor.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/local_database_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_sponsors_state.dart';
part 'fetch_sponsors_cubit.freezed.dart';

class FetchSponsorsCubit extends Cubit<FetchSponsorsState> {
  FetchSponsorsCubit({
    required ApiRepository apiRepository,
    required LocalDatabaseRepository localDatabaseRepository,
  }) : super(const FetchSponsorsState.initial()) {
    _apiRepository = apiRepository;
    _localDatabaseRepository = localDatabaseRepository;
  }

  late ApiRepository _apiRepository;
  late LocalDatabaseRepository _localDatabaseRepository;

  Future<void> fetchSponsors({
    bool forceRefresh = false,
  }) async {
    emit(const FetchSponsorsState.loading());
    try {
      final localSponsors = await _localDatabaseRepository.fetchSponsors();
      if (localSponsors.isNotEmpty && !forceRefresh) {
        emit(FetchSponsorsState.loaded(sponsors: localSponsors));
        return;
      }

      if (localSponsors.isEmpty || forceRefresh) {
        final sponsors = await _apiRepository.fetchSponsors();
        await _localDatabaseRepository.persistSponsors(sponsors: sponsors);
        final localSponsors = await _localDatabaseRepository.fetchSponsors();
        emit(FetchSponsorsState.loaded(sponsors: localSponsors));
        return;
      }
    } on Failure catch (e) {
      emit(FetchSponsorsState.error(e.message));
    } catch (e) {
      emit(FetchSponsorsState.error(e.toString()));
    }
  }
}
