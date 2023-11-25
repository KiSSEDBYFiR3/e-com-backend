import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/schema.dart';
import 'package:soc_backend/soc_backend.dart';

class SavesRequest implements Serializable {
  SavesRequest({this.batchId = '', this.id = 0, this.savedPageNum = ''});
  int id;
  String savedPageNum;
  String batchId;

  @override
  Map<String, dynamic> asMap() => {
        'id': id,
        'batch_id': batchId,
        'saved_page_num': savedPageNum,
      };

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    // TODO: implement documentSchema
    throw UnimplementedError();
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
    id = int.parse(object['id'].toString());
    batchId = object['batch_id'];
    savedPageNum = object['saved_page_num'];
  }
}
