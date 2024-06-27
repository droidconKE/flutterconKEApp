// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      slug: json['slug'] as String,
      sessionFormat: json['session_format'] as String,
      sessionLevel: json['session_level'] as String,
      speakers: (json['speakers'] as List<dynamic>?)
              ?.map((e) => Speaker.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'slug': instance.slug,
      'session_format': instance.sessionFormat,
      'session_level': instance.sessionLevel,
      'speakers': instance.speakers,
    };
