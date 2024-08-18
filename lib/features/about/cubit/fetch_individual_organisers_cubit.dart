import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/individual_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_individual_organiser.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/local_database_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_individual_organisers_state.dart';
part 'fetch_individual_organisers_cubit.freezed.dart';

class FetchIndividualOrganisersCubit
    extends Cubit<FetchIndividualOrganisersState> {
  FetchIndividualOrganisersCubit({
    required ApiRepository apiRepository,
    required LocalDatabaseRepository localDatabaseRepository,
  }) : super(const FetchIndividualOrganisersState.initial()) {
    _apiRepository = apiRepository;
    _localDatabaseRepository = localDatabaseRepository;
  }

  late ApiRepository _apiRepository;
  late LocalDatabaseRepository _localDatabaseRepository;

  Future<void> fetchIndividualOrganisers({
    bool forceRefresh = false,
  }) async {
    emit(const FetchIndividualOrganisersState.loading());

    try {
      final localIndividualOrganisers =
          await _localDatabaseRepository.fetchIndividualOrganisers();

      if (localIndividualOrganisers.isNotEmpty && !forceRefresh) {
        emit(
          FetchIndividualOrganisersState.loaded(
            individualOrganisers: localIndividualOrganisers,
          ),
        );
        return;
      }

      if (localIndividualOrganisers.isEmpty || forceRefresh) {
        final individualOrganisers =
            await _apiRepository.fetchIndividualOrganisers();
        await _localDatabaseRepository.persistIndividualOrganisers(
          organisers: individualOrganisers,
        );
        final localIndividualOrganisers =
            await _localDatabaseRepository.fetchIndividualOrganisers();
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
}
