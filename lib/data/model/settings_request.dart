import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/schema.dart';
import 'package:soc_backend/soc_backend.dart';

class SettingsRequest implements Serializable {
  SettingsRequest({
    this.volumeLevel,
    this.dialoguesWindowType,
    this.pagesChangeEffect,
    this.staticText,
    this.textGrowthSpeed,
  });
  double? volumeLevel;

  String? pagesChangeEffect;

  String? dialoguesWindowType;

  bool? staticText;

  double? textGrowthSpeed;
  @override
  Map<String, dynamic> asMap() => {
        'volume_level': volumeLevel,
        'dialogues_window_type': dialoguesWindowType,
        'static_text': staticText,
        'pages_change_effect': pagesChangeEffect,
        'text_growth_speed': textGrowthSpeed,
      };

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'volume_level': APISchemaObject.number(),
      'dialogues_window_type': APISchemaObject.string(),
      'static_text': APISchemaObject.string(),
      'pages_change_effect': APISchemaObject.string(),
      'text_growth_speed': APISchemaObject.number(),
    });
  }

  @override
  void read(Map<String, dynamic> object,
          {Iterable<String>? accept,
          Iterable<String>? ignore,
          Iterable<String>? reject,
          Iterable<String>? require}) =>
      readFromMap(object);

  @override
  void readFromMap(Map<String, dynamic> object) {
    volumeLevel = object['volume_level'];
    dialoguesWindowType = object['dialogues_window_type'];
    staticText = object['static_text'];
    pagesChangeEffect = object['pages_change_effect'];
    textGrowthSpeed = object['text_growth_speed'];
  }
}
