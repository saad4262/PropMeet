// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Auth _$AuthFromJson(Map<String, dynamic> json) => _Auth(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String? ?? '',
  email: json['email'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String? ?? '',
  tag: json['tag'] as String? ?? 'user',
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$AuthToJson(_Auth instance) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'email': instance.email,
  'avatarUrl': instance.avatarUrl,
  'tag': instance.tag,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
