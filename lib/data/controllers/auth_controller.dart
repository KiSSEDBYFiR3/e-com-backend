import 'package:googleapis/oauth2/v2.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:soc_backend/data/model/auth_request.dart';
import 'package:soc_backend/data/model/auth_response.dart';
import 'package:soc_backend/data/model/user.dart';
import 'package:soc_backend/domain/repository/auth_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';
import 'package:soc_backend/util/env_constants.dart';

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
      return await authRepository.authorize(authRequest, context, oauth2api);
    } catch (e) {
      return AppResponse.badRequest(details: 'token is incorrect');
    }
  }
}
