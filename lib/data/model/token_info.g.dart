// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) => TokenInfo(
      email: json['email'] as String,
      name: json['name'] as String,
      sub: json['sub'] as String,
      pitcure: json['pitcure'] as String?,
    );

Map<String, dynamic> _$TokenInfoToJson(TokenInfo instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'sub': instance.sub,
      'pitcure': instance.pitcure,
    };
