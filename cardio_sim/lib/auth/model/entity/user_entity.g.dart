// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      email: json['email'] as String,
      name: json['name'] as String,
      isAble: json['isAble'] as bool,
      affiliation: json['affiliation'] as String,
      position: json['position'] as String,
      s3Path: json['s3Path'] as String,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'isAble': instance.isAble,
      'affiliation': instance.affiliation,
      'position': instance.position,
      's3Path': instance.s3Path,
    };
