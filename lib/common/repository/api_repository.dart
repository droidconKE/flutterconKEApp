import 'package:fluttercon/common/data/models/feed.dart';
import 'package:fluttercon/common/data/models/individual_organiser.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/data/models/sponsor.dart';
import 'package:fluttercon/common/utils/env/flavor_config.dart';
import 'package:fluttercon/common/utils/network.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiRepository {
  final _networkUtil = NetworkUtil();

  final _eventSlug = FlutterConConfig.instance!.values.eventSlug;

  Future<List<Speaker>> fetchSpeakers({
    int perPage = 100,
    int page = 1,
  }) async {
    try {
      final response = await _networkUtil.getReq(
        '/events/$_eventSlug/speakers',
        queryParameters: {'per_page': perPage, 'page': page},
      );

      return SpeakerResponse.fromJson(response).data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Room>> fetchRooms() async {
    try {
      final response = await _networkUtil.getReq(
        '/events/$_eventSlug/rooms',
      );

      return RoomResponse.fromJson(response).data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Session>> fetchSessions({
    int perPage = 20,
    int page = 1,
  }) async {
    try {
      final response = await _networkUtil.getReq(
        '/events/$_eventSlug/schedule',
        queryParameters: {'per_page': perPage, 'page': page},
      );

      return SessionResponse.fromJson(response).data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Feed>> fetchFeeds({
    int perPage = 10,
    int page = 1,
  }) async {
    try {
      final response = await _networkUtil.getReq(
        '/events/$_eventSlug/feeds',
        queryParameters: {'per_page': perPage, 'page': page},
      );

      return FeedResponse.fromJson(response).data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Organiser>> fetchOrganisers({
    int perPage = 20,
    int page = 1,
  }) async {
    try {
      final response = await _networkUtil.getReq(
        '/organizers',
        queryParameters: {'per_page': perPage, 'page': page},
      );

      return OrganiserResponse.fromJson(response).data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Sponsor>> fetchSponsors({
    int perPage = 20,
    int page = 1,
  }) async {
    try {
      final response = await _networkUtil.getReq(
        '/events/$_eventSlug/sponsors',
        queryParameters: {'per_page': perPage, 'page': page},
      );

      return SponsorResponse.fromJson(response).data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<IndividualOrganiser>> fetchIndividualOrganisers({
    int perPage = 20,
    int page = 1,
  }) async {
    try {
      final response = await _networkUtil.getReq(
        '/organizers/droidcon-ke-645/team',
        queryParameters: {
          'per_page': perPage,
          'page': page,
          'type': 'individual',
        },
      );

      return IndividualOrganiserResponse.fromJson(response).data;
    } catch (e) {
      rethrow;
    }
  }
}
