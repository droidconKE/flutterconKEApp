import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/organising_team.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_organising_team_cubit.freezed.dart';
part 'fetch_organising_team_state.dart';

class FetchOrganisingTeamCubit extends Cubit<FetchOrganisingTeamState> {
  FetchOrganisingTeamCubit({required ApiRepository apiRepository})
      : super(const FetchOrganisingTeamState.initial()) {
    _apiRepository = apiRepository;
  }

  late ApiRepository _apiRepository;

  Future<void> fetchOrganisers() async {
    emit(const FetchOrganisingTeamState.loading());
    try {
      final organisers = await _apiRepository.fetchOrganisingTeam(event: 'droidcon-ke-645');
      emit(FetchOrganisingTeamState.loaded(organisers: organisers));
    } on Failure catch (e) {
      emit(FetchOrganisingTeamState.error(e.message));
    } catch (e) {
      emit(FetchOrganisingTeamState.error(e.toString()));
    }
  }
}
