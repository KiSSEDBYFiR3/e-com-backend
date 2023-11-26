import 'dart:developer' as dev;

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';
import 'package:soc_backend/util/env_constants.dart';

class AuthMiddlewareController extends Controller {
  @override
  FutureOr<RequestOrResponse?> handle(Request request) {
    try {
      final header = request.raw.headers.value(HttpHeaders.authorizationHeader);

      if (header == null) {
        return AppResponse.unauthorized();
      }

      final tokenJWT = const AuthorizationBearerParser().parse(header);

      final jwtSecretKey = EnvironmentConstants.jwtSecretKey;

      final jwtClaim = verifyJwtHS256Signature(tokenJWT ?? '', jwtSecretKey);
      jwtClaim.validate();

      request.attachments["userId"] = int.parse(jwtClaim["id"].toString());

      return request;
    } on JwtException catch (e) {
      dev.log(e.message);
      return AppResponse.unauthorized();
    }
  }
}
