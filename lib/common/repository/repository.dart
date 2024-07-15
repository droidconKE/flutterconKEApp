import 'package:dio/dio.dart';

import '../data/models/models.dart';

class Repository {
  Repository({required this.dio});

  final Dio dio;

  Future<List<Speaker>> fetchSpeakers({
    required String event,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await dio.get(
      '/events/$event/speakers',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    if (response.statusCode != 200) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': response.statusMessage,
      });
    }

    final speakersJson = List<Map<String, dynamic>>.from(
      (response.data as Map<String, dynamic>)['data'],
    );

    return [
      for (final speakerJson in speakersJson) Speaker.fromJson(speakerJson)
    ];
  }

  Future<List<Room>> fetchRooms({
    required String event,
  }) async {
    final response = await dio.get(
      '/events/$event/rooms',
    );

    if (response.statusCode != 200) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': response.statusMessage,
      });
    }

    final roomsJson = List<Map<String, dynamic>>.from(
      (response.data as Map<String, dynamic>)['data'],
    );

    return [
      for (final roomJson in roomsJson) Room.fromJson(roomJson),
    ];
  }

  Future<List<Session>> fetchSessions({
    required String event,
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await dio.get('/events/$event/sessions',
        queryParameters: {'per_page': perPage, 'page': page});

    if (response.statusCode != 200) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': response.statusMessage,
      });
    }

    final sessionsJson = List<Map<String, dynamic>>.from(
      (response.data as Map<String, dynamic>)['data'],
    );

    return [
      for (final sessionJson in sessionsJson) Session.fromJson(sessionJson)
    ];
  }
}
