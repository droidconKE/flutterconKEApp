import 'package:fluttercon/common/data/enums/search_result_type.dart';
import 'package:fluttercon/common/data/models/local/local_individual_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String title,
    required String subtitle,
    required String imageUrl,
    required SearchResultType type,
    LocalSession? session,
    LocalSpeaker? speaker,
    LocalIndividualOrganiser? organizer,
  }) = _SearchResult;
}
