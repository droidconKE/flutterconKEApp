import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/local/local_organiser.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/local_database_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_organisers_cubit.freezed.dart';
part 'fetch_organisers_state.dart';

class FetchOrganisersCubit extends Cubit<FetchOrganisersState> {
  FetchOrganisersCubit({
    required ApiRepository apiRepository,
    required LocalDatabaseRepository localDatabaseRepository,
  }) : super(const FetchOrganisersState.initial()) {
    _apiRepository = apiRepository;
    _localDatabaseRepository = localDatabaseRepository;
  }

  late ApiRepository _apiRepository;
  late LocalDatabaseRepository _localDatabaseRepository;

  Future<void> fetchOrganisers({
    bool forceRefresh = false,
  }) async {
    emit(const FetchOrganisersState.loading());
    try {
      final localOrganisers = await _localDatabaseRepository.fetchOrganisers();
      if (localOrganisers.isNotEmpty && !forceRefresh) {
        emit(FetchOrganisersState.loaded(organisers: localOrganisers));
        return;
      }

      if (localOrganisers.isEmpty || forceRefresh) {
        final organisers = await _apiRepository.fetchOrganisers();
        await _localDatabaseRepository.persistOrganisers(
          organisers: organisers,
        );
        final localOrganisers =
            await _localDatabaseRepository.fetchOrganisers();
        emit(FetchOrganisersState.loaded(organisers: localOrganisers));
        return;
      }
    } on Failure catch (e) {
      emit(FetchOrganisersState.error(e.message));
    } catch (e) {
      emit(FetchOrganisersState.error(e.toString()));
    }
  }
}
