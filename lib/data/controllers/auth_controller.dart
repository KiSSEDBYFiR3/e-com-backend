// ignore_for_file: implementation_imports

import 'dart:developer' as dev;

import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/response.dart';
import 'package:googleapis/oauth2/v2.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:soc_backend/data/model/auth_request.dart';
import 'package:soc_backend/data/model/auth_response.dart';
import 'package:soc_backend/domain/repository/auth_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';

class AuthController extends ResourceController {
  AuthController(
    this.oauth2api,
    this.context,
    this.authRepository,
  );

  final Oauth2Api oauth2api;
  final ManagedContext context;
  final IAuthRepository authRepository;

  late String accessToken;
  late String refreshToken;
  @Operation.post()
  Future<Response> authByGoogleToken(
    @Bind.body(require: ['idToken', 'accessToken']) AuthRequest authRequest,
  ) async {
    try {
      final response =
          await authRepository.authorize(authRequest, context, oauth2api);
      return Response.ok(response);
    } on JwtException catch (e) {
      return AppResponse.unauthorized(
        title: 'Invalid token',
        details: e.message,
      );
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    } catch (e) {
      dev.log(e.toString());
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
                  accessToken: '', userId: '', email: '', refreshToken: '')
              .documentSchema(context))
    };
  }
}
