import 'package:dio/dio.dart';

import 'package:fluttercon/common/data/models/models.dart';

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

    return SpeakerResponse.fromJson(response.data as Map<String, dynamic>).data;
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

    return RoomResponse.fromJson(response.data as Map<String, dynamic>).data;
  }

  Future<List<Session>> fetchSessions({
    required String event,
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await dio.get(
      '/events/$event/sessions',
      queryParameters: {'per_page': perPage, 'page': page},
    );

    if (response.statusCode != 200) {
      throw Exception({
        'statusCode': response.statusCode,
        'body': response.statusMessage,
      });
    }

    return SessionResponse.fromJson(response.data as Map<String, dynamic>).data;
  }
}
