import 'package:equatable/equatable.dart';

enum SearchResultType { session, speaker, sponsor, organizer }

class SearchResult extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final SearchResultType type;
  final dynamic extra;

  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.type,
    this.extra
  });

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl, type];
}