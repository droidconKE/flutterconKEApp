import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/local/local_individual_organiser.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_individual_organisers_state.dart';
part 'fetch_individual_organisers_cubit.freezed.dart';

class FetchIndividualOrganisersCubit
    extends Cubit<FetchIndividualOrganisersState> {
  FetchIndividualOrganisersCubit({
    required ApiRepository apiRepository,
    required DBRepository dBRepository,
  }) : super(const FetchIndividualOrganisersState.initial()) {
    _apiRepository = apiRepository;
    _dBRepository = dBRepository;
  }

  late ApiRepository _apiRepository;
  late DBRepository _dBRepository;

  Future<void> fetchIndividualOrganisers({
    bool forceRefresh = false,
  }) async {
    emit(const FetchIndividualOrganisersState.loading());

    try {
      final localIndividualOrganisers =
          await _dBRepository.fetchIndividualOrganisers();

      if (localIndividualOrganisers.isNotEmpty && !forceRefresh) {
        emit(
          FetchIndividualOrganisersState.loaded(
            individualOrganisers: localIndividualOrganisers,
          ),
        );
        await _networkFetch();
        return;
      }

      if (localIndividualOrganisers.isEmpty || forceRefresh) {
        await _networkFetch();
        final localIndividualOrganisers =
            await _dBRepository.fetchIndividualOrganisers();
        emit(
          FetchIndividualOrganisersState.loaded(
            individualOrganisers: localIndividualOrganisers,
          ),
        );
        return;
      }
    } on Failure catch (e) {
      emit(FetchIndividualOrganisersState.error(e.message));
    } catch (e) {
      emit(FetchIndividualOrganisersState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final individualOrganisers =
        await _apiRepository.fetchIndividualOrganisers();
    await _dBRepository.persistIndividualOrganisers(
      organisers: individualOrganisers,
    );
  }
}
