// ignore_for_file: implementation_imports
import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/response.dart';
import 'package:ecom_backend/data/model/auth_response.dart';
import 'package:ecom_backend/domain/repository/auth_repository.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/app_error_response.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AuthorizationController extends ResourceController {
  AuthorizationController(
    this.context,
    this.authRepository,
  );

  final ManagedContext context;
  final IAuthRepository authRepository;

  late String accessToken;
  late String refreshToken;

  @Operation.post()
  Future<Response> authorize() async {
    final uuid = request!.raw.headers.value('UUID') ?? '';
    final token =
        request!.raw.headers.value(HttpHeaders.authorizationHeader) ?? '';

    try {
      final response = await authRepository.authorize(token, context, uuid);

      return Response.ok(response);
    } on JwtException catch (e) {
      return AppResponse.unauthorized(
        title: 'Invalid token',
        details: e.message,
      );
    } on QueryException catch (e) {
      logger.severe(e.toString());
      return AppResponse.serverError(e, message: e.message);
    } catch (e) {
      logger.severe(e);
      return AppResponse.badRequest(details: 'token is incorrect');
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
          ).documentSchema(context))
    };
  }
}
