// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Session _$SessionFromJson(Map<String, dynamic> json) {
  return _Session.fromJson(json);
}

/// @nodoc
mixin _$Session {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_format')
  String get sessionFormat => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_level')
  String get sessionLevel => throw _privateConstructorUsedError;
  List<Speaker> get speakers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionCopyWith<Session> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) then) =
      _$SessionCopyWithImpl<$Res, Session>;
  @useResult
  $Res call(
      {String title,
      String description,
      String slug,
      @JsonKey(name: 'session_format') String sessionFormat,
      @JsonKey(name: 'session_level') String sessionLevel,
      List<Speaker> speakers});
}

/// @nodoc
class _$SessionCopyWithImpl<$Res, $Val extends Session>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? slug = null,
    Object? sessionFormat = null,
    Object? sessionLevel = null,
    Object? speakers = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      sessionFormat: null == sessionFormat
          ? _value.sessionFormat
          : sessionFormat // ignore: cast_nullable_to_non_nullable
              as String,
      sessionLevel: null == sessionLevel
          ? _value.sessionLevel
          : sessionLevel // ignore: cast_nullable_to_non_nullable
              as String,
      speakers: null == speakers
          ? _value.speakers
          : speakers // ignore: cast_nullable_to_non_nullable
              as List<Speaker>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionImplCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$$SessionImplCopyWith(
          _$SessionImpl value, $Res Function(_$SessionImpl) then) =
      __$$SessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      String slug,
      @JsonKey(name: 'session_format') String sessionFormat,
      @JsonKey(name: 'session_level') String sessionLevel,
      List<Speaker> speakers});
}

/// @nodoc
class __$$SessionImplCopyWithImpl<$Res>
    extends _$SessionCopyWithImpl<$Res, _$SessionImpl>
    implements _$$SessionImplCopyWith<$Res> {
  __$$SessionImplCopyWithImpl(
      _$SessionImpl _value, $Res Function(_$SessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? slug = null,
    Object? sessionFormat = null,
    Object? sessionLevel = null,
    Object? speakers = null,
  }) {
    return _then(_$SessionImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      sessionFormat: null == sessionFormat
          ? _value.sessionFormat
          : sessionFormat // ignore: cast_nullable_to_non_nullable
              as String,
      sessionLevel: null == sessionLevel
          ? _value.sessionLevel
          : sessionLevel // ignore: cast_nullable_to_non_nullable
              as String,
      speakers: null == speakers
          ? _value._speakers
          : speakers // ignore: cast_nullable_to_non_nullable
              as List<Speaker>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionImpl implements _Session {
  _$SessionImpl(
      {required this.title,
      required this.description,
      required this.slug,
      @JsonKey(name: 'session_format') required this.sessionFormat,
      @JsonKey(name: 'session_level') required this.sessionLevel,
      final List<Speaker> speakers = const []})
      : _speakers = speakers;

  factory _$SessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final String slug;
  @override
  @JsonKey(name: 'session_format')
  final String sessionFormat;
  @override
  @JsonKey(name: 'session_level')
  final String sessionLevel;
  final List<Speaker> _speakers;
  @override
  @JsonKey()
  List<Speaker> get speakers {
    if (_speakers is EqualUnmodifiableListView) return _speakers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_speakers);
  }

  @override
  String toString() {
    return 'Session(title: $title, description: $description, slug: $slug, sessionFormat: $sessionFormat, sessionLevel: $sessionLevel, speakers: $speakers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.sessionFormat, sessionFormat) ||
                other.sessionFormat == sessionFormat) &&
            (identical(other.sessionLevel, sessionLevel) ||
                other.sessionLevel == sessionLevel) &&
            const DeepCollectionEquality().equals(other._speakers, _speakers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      slug,
      sessionFormat,
      sessionLevel,
      const DeepCollectionEquality().hash(_speakers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      __$$SessionImplCopyWithImpl<_$SessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionImplToJson(
      this,
    );
  }
}

abstract class _Session implements Session {
  factory _Session(
      {required final String title,
      required final String description,
      required final String slug,
      @JsonKey(name: 'session_format') required final String sessionFormat,
      @JsonKey(name: 'session_level') required final String sessionLevel,
      final List<Speaker> speakers}) = _$SessionImpl;

  factory _Session.fromJson(Map<String, dynamic> json) = _$SessionImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  String get slug;
  @override
  @JsonKey(name: 'session_format')
  String get sessionFormat;
  @override
  @JsonKey(name: 'session_level')
  String get sessionLevel;
  @override
  List<Speaker> get speakers;
  @override
  @JsonKey(ignore: true)
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
