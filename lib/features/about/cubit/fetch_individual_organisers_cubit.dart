import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/individual_organiser.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_individual_organisers_state.dart';
part 'fetch_individual_organisers_cubit.freezed.dart';

class FetchIndividualOrganisersCubit
    extends Cubit<FetchIndividualOrganisersState> {
  FetchIndividualOrganisersCubit({
    required ApiRepository apiRepository,
  }) : super(const FetchIndividualOrganisersState.initial()) {
    _apiRepository = apiRepository;
  }

  late ApiRepository _apiRepository;

  Future<void> fetchIndividualOrganisers() async {
    emit(const FetchIndividualOrganisersState.loading());

    try {
      final individualOrganisers =
          await _apiRepository.fetchIndividualOrganisers();

      emit(
        FetchIndividualOrganisersState.loaded(
          individualOrganisers: individualOrganisers,
        ),
      );
    } on Failure catch (e) {
      emit(FetchIndividualOrganisersState.error(e.message));
    } catch (e) {
      emit(FetchIndividualOrganisersState.error(e.toString()));
    }
  }
}
