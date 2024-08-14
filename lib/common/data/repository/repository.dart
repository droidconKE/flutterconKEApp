import 'package:dio/dio.dart';
import 'package:fluttercon/common/data/models/feed.dart';

import 'package:fluttercon/common/data/models/models.dart';

class Repository {
  Repository({required this.dio});

  final Dio dio;

  Future<List<Speaker>> fetchSpeakers({
    required String event,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/events/$event/speakers',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    if (response.statusCode != 200) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': response.statusMessage,
      });
    }

    if (response.data == null) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': 'Data is null',
      });
    }

    return SpeakerResponse.fromJson(response.data!).data;
  }

  Future<List<Room>> fetchRooms({
    required String event,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/events/$event/rooms',
    );

    if (response.statusCode != 200) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': response.statusMessage,
      });
    }

    if (response.data == null) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': 'Data is null',
      });
    }

    if (response.data == null) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': 'Data is null',
      });
    }

    return RoomResponse.fromJson(response.data!).data;
  }

  Future<List<Session>> fetchSessions({
    required String event,
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/events/$event/sessions',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    if (response.statusCode != 200) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': response.statusMessage,
      });
    }

    if (response.data == null) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': 'Data is null',
      });
    }

    return SessionResponse.fromJson(response.data!).data;
  }

  Future<List<Feed>> fetchFeeds({
    required String event,
    int perPage = 10,
    int page = 1,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/events/$event/feeds',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    if (response.statusCode != 200) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': response.statusMessage,
      });
    }

    if (response.data == null) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': 'Data is null',
      });
    }

    return FeedResponse.fromJson(response.data!).data;
  }
}
