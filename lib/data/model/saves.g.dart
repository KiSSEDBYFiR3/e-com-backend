// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saves.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Save _$SaveFromJson(Map<String, dynamic> json) => _Save(
      batchId: json['batch_id'] as String? ?? '',
      savedPageNum: json['saved_page_num'] as String? ?? '',
      id: json['id'] as int?,
      userId: json['user_id'] as String? ?? '',
    );

Map<String, dynamic> _$SaveToJson(_Save instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'batch_id': instance.batchId,
      'saved_page_num': instance.savedPageNum,
    };
