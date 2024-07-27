import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/repository/repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  group(
    'Repository tests',
    () {
      late Dio dio;
      late MockResponse response;

      setUp(() {
        dio = MockDio();
        response = MockResponse();
      });

      group('Speaker Tests', () {
        test('Fetches Speakers correctly', () async {
          when(
            () =>
                dio.get(any(), queryParameters: any(named: 'queryParameters')),
          ).thenAnswer((_) async => response);

          when(() => response.statusCode).thenReturn(200);
          when(() => response.data).thenReturn(speakersMap);

          final repository = Repository(dio: dio);
          final speakers = await repository.fetchSpeakers(event: 'flutterCon');

          expect(
            speakers,
            isA<List<Speaker>>().having(
              (speakers) => speakers.length,
              'Fetched 2 speakers',
              equals(2),
            ),
          );
        });

        test(
          'Throws an exception if the response status code is not 200',
          () {
            when(
              () => dio.get(
                any(),
                queryParameters: any(named: 'queryParameters'),
              ),
            ).thenAnswer((_) async => response);

            when(() => response.statusCode).thenReturn(400);
            when(() => response.statusMessage).thenReturn('Resouce not found');

            final repository = Repository(dio: dio);

            expect(
              repository.fetchSpeakers(event: 'flutterCon'),
              throwsException,
            );
          },
        );
      });

      group('Room Tests', () {
        test('Fetches Rooms correctly', () async {
          when(
            () =>
                dio.get(any(), queryParameters: any(named: 'queryParameters')),
          ).thenAnswer((_) async => response);

          when(() => response.statusCode).thenReturn(200);
          when(() => response.data).thenReturn(roomsMap);

          final repository = Repository(dio: dio);
          final rooms = await repository.fetchRooms(event: 'flutterCon');

          expect(
            rooms,
            isA<List<Room>>(),
          );
        });

        test(
          'Throws an exception if the response status code is not 200',
          () {
            when(
              () => dio.get(
                any(),
                queryParameters: any(named: 'queryParameters'),
              ),
            ).thenAnswer((_) async => response);

            when(() => response.statusCode).thenReturn(400);
            when(() => response.statusMessage).thenReturn('Resouce not found');

            final repository = Repository(dio: dio);

            expect(
              repository.fetchRooms(event: 'flutterCon'),
              throwsException,
            );
          },
        );
      });

      group('Session Tests', () {
        test('Fetches Sessions correctly', () async {
          when(
            () =>
                dio.get(any(), queryParameters: any(named: 'queryParameters')),
          ).thenAnswer((_) async => response);

          when(() => response.statusCode).thenReturn(200);
          when(() => response.data).thenReturn(sessionsMap);

          final repository = Repository(dio: dio);
          final sessions = await repository.fetchSessions(event: 'flutterCon');

          expect(
            sessions,
            isA<List<Session>>(),
          );
        });

        test(
          'Throws an exception if the response status code is not 200',
          () {
            when(
              () => dio.get(
                any(),
                queryParameters: any(named: 'queryParameters'),
              ),
            ).thenAnswer((_) async => response);

            when(() => response.statusCode).thenReturn(400);
            when(() => response.statusMessage).thenReturn('Resouce not found');

            final repository = Repository(dio: dio);

            expect(
              repository.fetchSessions(event: 'flutterCon'),
              throwsException,
            );
          },
        );
      });
    },
  );
}

// All these copied from postman files

const speakersMap = {
  'data': [
    {
      'name': 'Charles Muchene',
      'tagline': 'SenseiDev',
      'biography':
          'Lead Mobile Engineer at a motorcycle ride sharing company in Kampala, Uganda. Freshly brewed café latte does the magic. :D',
      'avatar':
          'https://sessionize.com/image?f=b8c9f0300f2d7242f78c4df95bf297f4,400,400,1,0,79-31e3-4c9c-88fe-30d51990bf64.08ff2466-3b86-4bb5-9292-b4b493df6e6f.JPG',
      'twitter': 'https://twitter.com/charlesmuchene',
      'facebook': null,
      'linkedin': null,
      'instagram': null,
      'blog': null,
      'company_website': 'http://www.safeboda.com',
    },
    {
      'name': 'Clare Mburu',
      'tagline': 'CTO,BabyPie',
      'biography':
          'A passionate technology enthusiast, Android Web applications developer, community lover',
      'avatar':
          'https://sessionize.com/image?f=df156e6bac7b2939d702bff0f158b079,400,400,1,0,1f-e683-41e9-9310-ad43170d265c.2e3da599-e070-4753-a169-cd35f5577464.jpg',
      'twitter': 'https://twitter.com/Mburuclare?s=09',
      'facebook': null,
      'linkedin': null,
      'instagram': null,
      'blog': null,
      'company_website': null,
    }
  ],
  'meta': {
    'paginator': {
      'count': 27,
      'per_page': '15',
      'current_page': 1,
      'next_page':
          'http://localhost:8000/api/v1/events/droidconke2019-444/speakers?per_page=15&page=2',
      'has_more_pages': true,
      'next_page_url':
          'http://localhost:8000/api/v1/events/droidconke2019-444/speakers?per_page=15&page=2',
      'previous_page_url': null,
    },
  },
};

const roomsMap = {
  'data': [
    {'title': 'Room A', 'id': 1},
    {'title': 'Room B', 'id': 2},
    {'title': 'Room C', 'id': 3},
  ],
};

const sessionsMap = {
  'data': [
    {
      'title': 'Retrofiti: A Pragmatic Approach to using Retrofit in Android',
      'description':
          'This session is codelab covering some of the best practices and recommended approaches to building an application using the retrofit library.',
      'slug':
          'retrofiti-a-pragmatic-approach-to-using-retrofit-in-android-1583941090',
      'session_format': 'Codelab / Workshop',
      'session_level': 'Intermediate',
      'speakers': [
        {
          'name': 'Roger Taracha',
          'tagline': 'TheDancerCodes',
          'biography':
              "Roger Taracha is a Software Engineer by profession who also loves the Arts. \r\n\r\nWhen he isn't writing code or mentoring software developers, you can find him throwing down on the dance floor.\r\nHence his alias, TheDancerCodes.\r\n\r\nHe is currently a Learning Facilitator and Lead Android Engineer at Andela Kenya where he drives teams of software developers (junior and senior) to rapidly develop great software products. \r\n\r\nHe also supports the learning and professional development of dozens of Africa's most talented software developers every day.",
          'avatar':
              'https://sessionize.com/image?f=b365d37c5064aa5ca332ca036b08f6ec,400,400,1,0,aa-600e-4800-bfee-afe74104c8e8.6708c35c-8578-40f1-aa56-d8991598d826.jpg',
          'twitter': 'https://twitter.com/TheDancerCodes',
          'facebook': null,
          'linkedin': null,
          'instagram': null,
          'blog': 'https://medium.com/@thedancercodes',
          'company_website': 'https://andela.com/',
        }
      ],
    },
    {
      'title': 'Jetpack: An Overview',
      'description':
          "During Google IO 2018, the Android team announced Jetpack, a set of libraries, tools and architectural guidance to help make it quick and easy to build great Android apps. Jetpack includes the previously existing Architecture Components and adds many libraries and tools that make development easier across a wide range of areas. In this session, we'll go through the available libraries and APIs and discuss how they can make development easier, faster and more intuitive.",
      'slug': 'jetpack-an-overview-1583941090',
      'session_format': 'Regular Session',
      'session_level': 'Intermediate',
      'speakers': [
        {
          'name': 'Eston Karumbi',
          'tagline': 'Android Developer',
          'biography': 'Developer, learner, wanderer, DIY auto mechanic.',
          'avatar':
              'https://sessionize.com/image?f=f0a21786344cb927ecf4ca9f6b8cd10e,400,400,1,0,a3-ce70-41a6-b987-2afe691f0864.0311c9f2-10e0-41af-82f4-c660e307c405.jpg',
          'twitter': 'https://twitter.com/doc2dev',
          'facebook': null,
          'linkedin': null,
          'instagram': null,
          'blog': null,
          'company_website': null,
        }
      ],
    }
  ],
  'meta': {
    'paginator': {
      'count': 2,
      'per_page': '20',
      'current_page': 1,
      'next_page':
          'http://localhost:8000/api/v1/events/droidconke2019-444/sessions?per_page=20&page=2',
      'has_more_pages': true,
      'next_page_url':
          'http://localhost:8000/api/v1/events/droidconke2019-444/sessions?per_page=20&page=2',
      'previous_page_url': null,
    },
  },
};
