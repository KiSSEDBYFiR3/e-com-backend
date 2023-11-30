import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/schema.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/data/model/page.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:conduit_open_api/src/v3/types.dart';

part 'pages_response.g.dart';

@JsonSerializable(
  createFactory: false,
  createToJson: true,
  fieldRename: FieldRename.snake,
)
class PagesResponse implements Serializable {
  const PagesResponse({
    required this.pages,
    required this.nextPagesBatch,
    required this.currentScenarySoundtrack,
  });

  final List<Page> pages;

  final String nextPagesBatch;

  final String currentScenarySoundtrack;

  Map<String, dynamic> toJson() => _$PagesResponseToJson(this);

  @override
  Map<String, dynamic> asMap() => toJson();

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'pages': APISchemaObject.array(
        ofType: APIType.object,
        ofSchema: Page().documentSchema(context),
      ),
      'next_pages_batch': APISchemaObject.string(),
      'current_scenary_soundtrack': APISchemaObject.string()
    });
  }

  @override
  void read(
    Map<String, dynamic> object, {
    Iterable<String>? accept,
    Iterable<String>? ignore,
    Iterable<String>? reject,
    Iterable<String>? require,
  }) {}

  @override
  void readFromMap(Map<String, dynamic> object) {}
}
