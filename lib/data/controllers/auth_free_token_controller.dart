import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/response.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:soc_backend/data/model/auth_response.dart';
import 'package:soc_backend/domain/repository/auth_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';
import 'package:soc_backend/core/exception/user_not_found.dart';

class AuthFreeTokenController extends ResourceController {
  AuthFreeTokenController(this.context, this.authRepository);
  final ManagedContext context;

  final IAuthRepository authRepository;

  @Operation.post()
  Future<Response> updateFreeToken(@Bind.query("token") String token) async {
    try {
      final response = await authRepository.updateFreeToken(token, context);
      return Response.ok(response);
    } on JwtException catch (e) {
      return AppResponse.unauthorized(
        title: 'Invalid token',
        details: e.message,
      );
    } on UserNotFound catch (_) {
      return AppResponse.unauthorized(title: 'user not found');
    }
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      '200': APIResponse.schema(
        '',
        const UserAuthResponse(
          accessToken: '',
          userId: '',
          email: '',
          refreshToken: '',
          id: 0,
        ).documentSchema(context),
      )
    };
  }
}
