import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_open_api/v3.dart';

import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable(
  createToJson: true,
  createFactory: true,
  fieldRename: FieldRename.snake,
)
class UserAuthResponse implements Serializable {
  const UserAuthResponse({
    required this.id,
    required this.refreshToken,
    required this.accessToken,
  });
  final int id;
  final String refreshToken;
  final String accessToken;

  @override
  Map<String, dynamic> asMap() => _$UserAuthResponseToJson(this);

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'id': APISchemaObject.integer(),
      'refresh_token': APISchemaObject.string(),
      'access_token': APISchemaObject.string(),
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

  @override
  void readFromMap(Map<String, dynamic> object) =>
      _$UserAuthResponseFromJson(object);
}
