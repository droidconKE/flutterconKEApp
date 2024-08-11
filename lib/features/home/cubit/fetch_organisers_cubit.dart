import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_organisers_cubit.freezed.dart';
part 'fetch_organisers_state.dart';

class FetchOrganisersCubit extends Cubit<FetchOrganisersState> {
  FetchOrganisersCubit({required ApiRepository apiRepository})
      : super(const FetchOrganisersState.initial()) {
    _apiRepository = apiRepository;
  }

  late ApiRepository _apiRepository;

  Future<void> fetchOrganisers() async {
    emit(const FetchOrganisersState.loading());
    try {
      final organisers = await _apiRepository.fetchOrganisers();
      emit(FetchOrganisersState.loaded(organisers: organisers));
    } on Failure catch (e) {
      emit(FetchOrganisersState.error(e.message));
    } catch (e) {
      emit(FetchOrganisersState.error(e.toString()));
    }
  }
}
