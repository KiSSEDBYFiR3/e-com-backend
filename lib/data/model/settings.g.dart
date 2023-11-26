// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
      volumeLevel: (json['volume_level'] as num?)?.toDouble() ?? 100,
      id: json['id'] as String? ?? '',
      pagesChangeEffect: json['pages_change_effect'] as String? ?? 'none',
      dialoguesWindowType:
          json['dialogues_window_type'] as String? ?? 'bottomBarLike',
      staticText: json['static_text'] as bool? ?? true,
      textGrowthSpeed: (json['text_growth_speed'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
      'id': instance.id,
      'volume_level': instance.volumeLevel,
      'pages_change_effect': instance.pagesChangeEffect,
      'dialogues_window_type': instance.dialoguesWindowType,
      'static_text': instance.staticText,
      'text_growth_speed': instance.textGrowthSpeed,
    };
