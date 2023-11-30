import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/schema.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:soc_backend/soc_backend.dart';

part 'auth_response.g.dart';

@JsonSerializable(
  createToJson: true,
  createFactory: true,
  fieldRename: FieldRename.snake,
)
class UserAuthResponse implements Serializable {
  const UserAuthResponse({
    required this.id,
    required this.email,
    required this.refreshToken,
    required this.accessToken,
    required this.userId,
    this.name,
  });
  final int id;
  final String userId;
  final String email;
  final String? name;
  final String refreshToken;
  final String accessToken;

  @override
  Map<String, dynamic> asMap() => _$UserAuthResponseToJson(this);

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      'user_id': APISchemaObject.string(),
      'email': APISchemaObject.string(),
      'name': APISchemaObject.string(),
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
