import 'package:bloc/bloc.dart';
import 'package:fluttercon/search/cubit/search_state.dart';
import 'package:injectable/injectable.dart';
import '../../../common/data/models/failure.dart';
import '../../../common/repository/api_repository.dart';
import '../../../common/repository/db_repository.dart';
import '../models/search_result.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final ApiRepository _apiRepository;
  final DBRepository _dbRepository;

  SearchCubit(
      this._apiRepository,
      this._dbRepository,
      ) : super(const SearchInitial());

  Future<void> search(String query) async {
    emit(const SearchLoading());
    try {
      final sessions = await _dbRepository.fetchSessions();
      final speakers = await _dbRepository.fetchSpeakers();
      final sponsors = await _dbRepository.fetchSponsors();
      final organizers = await _dbRepository.fetchOrganisers();

      final results = [
        ...sessions
            .where((session) =>
        session.title.toLowerCase().contains(query.toLowerCase()) ||
            session.description.toLowerCase().contains(query.toLowerCase()))
            .map((session) => SearchResult(
            id: session.serverId.toString(),
            title: session.title,
            subtitle: 'Session',
            imageUrl: session.sessionImage,
            type: SearchResultType.session,
            extra: session

        )),
        ...speakers
            .where((speaker) =>
        speaker.name.toLowerCase().contains(query.toLowerCase()) ||
            (speaker.tagline?.toLowerCase() ?? '')
                .contains(query.toLowerCase()))
            .map((speaker) => SearchResult(
            id: speaker.id.toString(),
            title: speaker.name,
            subtitle: speaker.tagline ?? '',
            imageUrl: speaker.avatar,
            type: SearchResultType.speaker,
            extra: speaker
        )),
        ...sponsors
            .where((sponsor) =>
            sponsor.name.toLowerCase().contains(query.toLowerCase()))
            .map((sponsor) => SearchResult(
          id: sponsor.id.toString(),
          title: sponsor.name,
          subtitle: 'Sponsor',
          imageUrl: sponsor.logo,
          type: SearchResultType.sponsor,
        )),
        ...organizers
            .where((organizer) =>
            organizer.name.toLowerCase().contains(query.toLowerCase()))
            .map((organizer) => SearchResult(
          id: organizer.id.toString(),
          title: organizer.name,
          subtitle: 'Organizer',
          imageUrl: organizer.logo,
          type: SearchResultType.organizer,

        )),
      ];

      emit(SearchLoaded(results: results));
    } on Failure catch (e) {
      emit(SearchError(message: e.message));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  void clearSearch() {
    emit(const SearchInitial());
  }
}
