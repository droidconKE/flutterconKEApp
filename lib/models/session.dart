import 'package:freezed_annotation/freezed_annotation.dart';

import 'speaker.dart';

part 'session.freezed.dart';
part 'session.g.dart';

// {
//       "title": "Retrofiti: A Pragmatic Approach to using Retrofit in Android",
//       "description": "This session is codelab covering some of the best practices and recommended approaches to building an application using the retrofit library.",
//       "slug": "retrofiti-a-pragmatic-approach-to-using-retrofit-in-android-1583941090",
//       "session_format": "Codelab / Workshop",
//       "session_level": "Intermediate",
//       "speakers": [
//         {
//           "name": "Roger Taracha",
//           "tagline": "TheDancerCodes",
//           "biography": "Roger Taracha is a Software Engineer by profession who also loves the Arts. \r\n\r\nWhen he isn't writing code or mentoring software developers, you can find him throwing down on the dance floor.\r\nHence his alias, TheDancerCodes.\r\n\r\nHe is currently a Learning Facilitator and Lead Android Engineer at Andela Kenya where he drives teams of software developers (junior and senior) to rapidly develop great software products. \r\n\r\nHe also supports the learning and professional development of dozens of Africa's most talented software developers every day.",
//           "avatar": "https://sessionize.com/image?f=b365d37c5064aa5ca332ca036b08f6ec,400,400,1,0,aa-600e-4800-bfee-afe74104c8e8.6708c35c-8578-40f1-aa56-d8991598d826.jpg",
//           "twitter": "https://twitter.com/TheDancerCodes",
//           "facebook": null,
//           "linkedin": null,
//           "instagram": null,
//           "blog": "https://medium.com/@thedancercodes",
//           "company_website": "https://andela.com/"
//         }
//       ]
//     },

@freezed
class Session with _$Session {
  factory Session({
    required String title,
    required String description,
    required String slug,
    @JsonKey(name: 'session_format')
    required String sessionFormat,
    @JsonKey(name: 'session_level')
    required String sessionLevel,
    @Default([]) List<Speaker> speakers,
  }) = _Session;

  factory Session.fromJson(Map<String, Object?> json) => _$SessionFromJson(json);
}
