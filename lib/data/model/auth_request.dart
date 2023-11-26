import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_open_api/src/v3/schema.dart';

class AuthRequest implements Serializable {
  AuthRequest({
    this.idToken = '',
    this.accessToken = '',
  });

  String idToken;
  String accessToken;

  @override
  Map<String, dynamic> asMap() => {
        'idToken': idToken,
        'accessToken': accessToken,
      };

  @override
  void readFromMap(Map<String, dynamic> object) {
    idToken = object['id_token'];
    accessToken = object['access_token'];
  }

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'id_token': APISchemaObject.string(),
      'access_token': APISchemaObject.string(),
    });
  }

  @override
  void read(Map<String, dynamic> object,
          {Iterable<String>? accept,
          Iterable<String>? ignore,
          Iterable<String>? reject,
          Iterable<String>? require}) =>
      readFromMap(object);
}
