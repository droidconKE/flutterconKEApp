// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeakerImpl _$$SpeakerImplFromJson(Map<String, dynamic> json) =>
    _$SpeakerImpl(
      name: json['name'] as String,
      tagline: json['tagline'] as String?,
      biography: json['biography'] as String,
      avatar: json['avatar'] as String,
      twitter: json['twitter'] as String?,
      facebook: json['facebook'] as String?,
      linkedin: json['linkedin'] as String?,
      instagram: json['instagram'] as String?,
      blog: json['blog'] as String?,
      companyWebsite: json['company_website'] as String?,
    );

Map<String, dynamic> _$$SpeakerImplToJson(_$SpeakerImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tagline': instance.tagline,
      'biography': instance.biography,
      'avatar': instance.avatar,
      'twitter': instance.twitter,
      'facebook': instance.facebook,
      'linkedin': instance.linkedin,
      'instagram': instance.instagram,
      'blog': instance.blog,
      'company_website': instance.companyWebsite,
    };
