import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/local/local_sponsor.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_sponsors_state.dart';
part 'fetch_sponsors_cubit.freezed.dart';

class FetchSponsorsCubit extends Cubit<FetchSponsorsState> {
  FetchSponsorsCubit({
    required ApiRepository apiRepository,
    required DBRepository dBRepository,
  }) : super(const FetchSponsorsState.initial()) {
    _apiRepository = apiRepository;
    _dBRepository = dBRepository;
  }

  late ApiRepository _apiRepository;
  late DBRepository _dBRepository;

  Future<void> fetchSponsors({
    bool forceRefresh = false,
  }) async {
    emit(const FetchSponsorsState.loading());
    try {
      final localSponsors = await _dBRepository.fetchSponsors();
      if (localSponsors.isNotEmpty && !forceRefresh) {
        emit(FetchSponsorsState.loaded(sponsors: localSponsors));
        await _networkFetch();
        return;
      }

      if (localSponsors.isEmpty || forceRefresh) {
        await _networkFetch();
        final localSponsors = await _dBRepository.fetchSponsors();
        emit(FetchSponsorsState.loaded(sponsors: localSponsors));
        return;
      }
    } on Failure catch (e) {
      emit(FetchSponsorsState.error(e.message));
    } catch (e) {
      emit(FetchSponsorsState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final sponsors = await _apiRepository.fetchSponsors();
    await _dBRepository.persistSponsors(sponsors: sponsors);
  }
}
