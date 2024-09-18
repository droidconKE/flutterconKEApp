import 'package:fluttercon/common/data/models/search_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = SearchInitial;
  const factory SearchState.loading() = SearchLoading;
  const factory SearchState.loaded({required List<SearchResult> results}) =
      SearchLoaded;
  const factory SearchState.error({required String message}) = SearchError;
}
