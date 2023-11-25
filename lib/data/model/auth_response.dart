import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable(
  createToJson: true,
  createFactory: false,
  fieldRename: FieldRename.snake,
)
class UserAuthResponse {
  const UserAuthResponse({
    required this.userId,
    required this.email,
    required this.refreshToken,
    required this.accessToken,
    this.name,
  });
  final String userId;
  final String email;
  final String? name;
  final String refreshToken;
  final String accessToken;

  Map<String, dynamic> toJson() => _$UserAuthResponseToJson(this);
}
