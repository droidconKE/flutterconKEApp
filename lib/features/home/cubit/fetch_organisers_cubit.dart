import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/local/local_organiser.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_organisers_cubit.freezed.dart';
part 'fetch_organisers_state.dart';

class FetchOrganisersCubit extends Cubit<FetchOrganisersState> {
  FetchOrganisersCubit({
    required ApiRepository apiRepository,
    required DBRepository dBRepository,
  }) : super(const FetchOrganisersState.initial()) {
    _apiRepository = apiRepository;
    _dBRepository = dBRepository;
  }

  late ApiRepository _apiRepository;
  late DBRepository _dBRepository;

  Future<void> fetchOrganisers({
    bool forceRefresh = false,
  }) async {
    emit(const FetchOrganisersState.loading());
    try {
      final localOrganisers = await _dBRepository.fetchOrganisers();
      if (localOrganisers.isNotEmpty && !forceRefresh) {
        emit(FetchOrganisersState.loaded(organisers: localOrganisers));
        await _networkFetch();
        return;
      }

      if (localOrganisers.isEmpty || forceRefresh) {
        await _networkFetch();
        final localOrganisers = await _dBRepository.fetchOrganisers();
        emit(FetchOrganisersState.loaded(organisers: localOrganisers));
        return;
      }
    } on Failure catch (e) {
      emit(FetchOrganisersState.error(e.message));
    } catch (e) {
      emit(FetchOrganisersState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final organisers = await _apiRepository.fetchOrganisers();
    await _dBRepository.persistOrganisers(organisers: organisers);
  }
}
