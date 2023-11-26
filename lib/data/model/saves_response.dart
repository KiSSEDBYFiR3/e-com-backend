import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/schema.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/data/model/saves.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:conduit_open_api/src/v3/types.dart';

part 'saves_response.g.dart';

@JsonSerializable(
  createToJson: true,
  createFactory: false,
  fieldRename: FieldRename.snake,
)
class SavesResponse implements Serializable {
  const SavesResponse(this.saves);
  final List<Save> saves;

  Map<String, dynamic> toJson() => _$SavesResponseToJson(this);

  @override
  Map<String, dynamic> asMap() => toJson();

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'saves': APISchemaObject.array(
        ofType: APIType.object,
        ofSchema: Save().documentSchema(context),
      )
    });
  }

  @override
  void read(Map<String, dynamic> object,
      {Iterable<String>? accept,
      Iterable<String>? ignore,
      Iterable<String>? reject,
      Iterable<String>? require}) {}

  @override
  void readFromMap(Map<String, dynamic> object) {}
}
