import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:ecom_backend/core/exception/user_not_found.dart';
import 'package:ecom_backend/data/model/auth_response.dart';
import 'package:ecom_backend/domain/repository/auth_repository.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/app_error_response.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AuthRefreshTokenController extends ResourceController {
  AuthRefreshTokenController(this.context, this.authRepository);
  final ManagedContext context;

  final IAuthRepository authRepository;

  @Operation.post()
  Future<Response> updateFreeToken() async {
    final uuid = request!.raw.headers.value('UUID') ?? '';
    final token =
        request!.raw.headers.value(HttpHeaders.authorizationHeader) ?? '';

    try {
      final response = await authRepository.tokenRefresh(token, context, uuid);
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
          refreshToken: '',
          id: 0,
        ).documentSchema(context),
      )
    };
  }
}
