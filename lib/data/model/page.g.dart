// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Page _$PageFromJson(Map<String, dynamic> json) => _Page(
      id: json['id'] as int? ?? 0,
      currentCharacter: json['current_character'] as String? ?? '',
      scenaryImage: json['scenary_image'] as String? ?? '',
      scenaryTransitionEffect:
          json['scenary_transition_effect'] as String? ?? '',
      animationEffect: json['animation_effect'] as String? ?? '',
      characterImage: json['character_image'] as String? ?? '',
      currentDialoguePhrase: json['current_dialogue_phrase'] as String? ?? '',
      endOfScenary: json['end_of_scenary'] as bool? ?? false,
      batchId: json['batch_id'] as String? ?? '',
      soundTrack: json['sound_track'] as String? ?? '',
      nextBatch: json['next_batch'] as String? ?? '',
    );

Map<String, dynamic> _$PageToJson(_Page instance) => <String, dynamic>{
      'id': instance.id,
      'batch_id': instance.batchId,
      'current_character': instance.currentCharacter,
      'current_dialogue_phrase': instance.currentDialoguePhrase,
      'character_image': instance.characterImage,
      'scenary_image': instance.scenaryImage,
      'scenary_transition_effect': instance.scenaryTransitionEffect,
      'animation_effect': instance.animationEffect,
      'end_of_scenary': instance.endOfScenary,
      'next_batch': instance.nextBatch,
      'sound_track': instance.soundTrack,
    };
