import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/common/data/models/failure.dart';
import 'package:fluttercon/common/repository/db_repository.dart';
import 'package:fluttercon/search/cubit/search_state.dart';
import 'package:fluttercon/search/models/search_result.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
    this._dbRepository,
  ) : super(const SearchState.initial());

  final DBRepository _dbRepository;

  Future<void> search(String query) async {
    emit(const SearchState.loading());
    try {
      final sessions = await _dbRepository.searchSessions(query);
      final speakers = await _dbRepository.searchSpeakers(query);
      final sponsors = await _dbRepository.searchSponsors(query);
      final organizers = await _dbRepository.searchOrganisers(query);

      final results = [
        ...sessions.map(
          (session) => SearchResult(
            id: session.serverId.toString(),
            title: session.title,
            subtitle: 'Session',
            imageUrl: session.sessionImage,
            type: SearchResultType.session,
            session: session,
          ),
        ),
        ...speakers.map(
          (speaker) => SearchResult(
            id: speaker.id.toString(),
            title: speaker.name,
            subtitle: speaker.tagline ?? '',
            imageUrl: speaker.avatar,
            type: SearchResultType.speaker,
            speaker: speaker,
          ),
        ),
        ...sponsors.map(
          (sponsor) => SearchResult(
            id: sponsor.id.toString(),
            title: sponsor.name,
            subtitle: 'Sponsor',
            imageUrl: sponsor.logo,
            type: SearchResultType.sponsor,
            sponsor: sponsor,
          ),
        ),
        ...organizers.map(
          (organizer) => SearchResult(
            id: organizer.id.toString(),
            title: organizer.name,
            subtitle: 'Organizer',
            imageUrl: organizer.logo,
            type: SearchResultType.organizer,
            organizer: organizer,
          ),
        ),
      ];

      emit(SearchState.loaded(results: results));
    } on Failure catch (e) {
      emit(SearchState.error(message: e.message));
    } catch (e) {
      emit(SearchState.error(message: e.toString()));
    }
  }

  void clearSearch() {
    emit(const SearchState.initial());
  }
}
