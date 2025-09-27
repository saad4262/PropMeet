// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Auth _$AuthFromJson(Map<String, dynamic> json) => _Auth(
  userId: json['userId'] as String,
  email: json['email'] as String? ?? '',
  tag: json['tag'] as String? ?? 'user',
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$AuthToJson(_Auth instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'tag': instance.tag,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
