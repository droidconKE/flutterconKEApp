import 'package:fluttercon/common/data/models/local/local_organiser.dart';
import 'package:fluttercon/common/data/models/local/local_session.dart';
import 'package:fluttercon/common/data/models/local/local_speaker.dart';
import 'package:fluttercon/common/data/models/local/local_sponsor.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';

enum SearchResultType { session, speaker, sponsor, organizer }

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String id,
    required String title,
    required String subtitle,
    required String imageUrl,
    required SearchResultType type,
    LocalSession? session,
    LocalSpeaker? speaker,
    LocalSponsor? sponsor,
    LocalOrganiser? organizer,
  }) = _SearchResult;
}
