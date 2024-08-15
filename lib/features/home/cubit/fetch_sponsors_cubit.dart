import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/data/models/sponsor.dart';
import 'package:fluttercon/common/repository/api_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_sponsors_state.dart';
part 'fetch_sponsors_cubit.freezed.dart';

class FetchSponsorsCubit extends Cubit<FetchSponsorsState> {
  FetchSponsorsCubit({
    required ApiRepository apiRepository,
  }) : super(const FetchSponsorsState.initial()) {
    _apiRepository = apiRepository;
  }

  late ApiRepository _apiRepository;

  Future<void> fetchSponsors() async {
    emit(const FetchSponsorsState.loading());
    try {
      final sponsors = await _apiRepository.fetchSponsors();
      emit(FetchSponsorsState.loaded(sponsors));
    } on Failure catch (e) {
      emit(FetchSponsorsState.error(e.message));
    } catch (e) {
      emit(FetchSponsorsState.error(e.toString()));
    }
  }
}
