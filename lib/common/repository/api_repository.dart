import 'package:fluttercon/common/data/models/feed.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/data/models/sponsor.dart';
import 'package:fluttercon/common/utils/network.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiRepository {
  final _networkUtil = NetworkUtil();

  Future<List<Speaker>> fetchSpeakers({
    required String event,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _networkUtil.getReq(
      '/events/$event/speakers',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    return SpeakerResponse.fromJson(response).data;
  }

  Future<List<Room>> fetchRooms({
    required String event,
  }) async {
    final response = await _networkUtil.getReq(
      '/events/$event/rooms',
    );

    return RoomResponse.fromJson(response).data;
  }

  Future<List<Session>> fetchSessions({
    required String event,
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await _networkUtil.getReq(
      '/events/$event/sessions',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    return SessionResponse.fromJson(response).data;
  }

  Future<List<Feed>> fetchFeeds({
    required String event,
    int perPage = 10,
    int page = 1,
  }) async {
    final response = await _networkUtil.getReq(
      '/events/$event/feeds',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    return FeedResponse.fromJson(response).data;
  }

  Future<List<Organiser>> fetchOrganisers({
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await _networkUtil.getReq(
      '/organizers',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    return OrganiserResponse.fromJson(response).data;
  }

  Future<List<Sponsor>> fetchSponsors({
    required String event,
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await _networkUtil.getReq(
      '/events/$event/sponsors',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    return SponsorResponse.fromJson(response).data;
  }
}
