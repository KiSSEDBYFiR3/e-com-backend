import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:ecom_backend/ecom_backend.dart';

class FavoritesRequest implements Serializable {
  FavoritesRequest({
    this.id = 0,
  });

  int id;

  @override
  Map<String, dynamic> asMap() => {
        'id': id,
      };

  @override
  void readFromMap(Map<String, dynamic> object) {
    id = object['id'];
  }

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'id': APISchemaObject.integer(),
    });
  }

  @override
  void read(
    Map<String, dynamic> object, {
    Iterable<String>? accept,
    Iterable<String>? ignore,
    Iterable<String>? reject,
    Iterable<String>? require,
  }) =>
      readFromMap(object);
}
