import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_open_api/v3.dart';

class AuthRequest implements Serializable {
  AuthRequest({
    this.accessToken = '',
  });

  String? accessToken;
  String? refreshToken;

  @override
  Map<String, dynamic> asMap() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };

  @override
  void readFromMap(Map<String, dynamic> object) {
    accessToken = object['access_token'];
    refreshToken = object['refresh_token'];
  }

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'access_token': APISchemaObject.string(),
      'refresh_token': APISchemaObject.string(),
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
