import 'package:googleapis/oauth2/v2.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:soc_backend/data/model/auth_request.dart';
import 'package:soc_backend/data/model/auth_response.dart';
import 'package:soc_backend/data/model/user.dart';
import 'package:soc_backend/domain/repository/auth_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';
import 'package:soc_backend/util/env_constants.dart';

class AuthRepository implements IAuthRepository {
  late String accessToken;
  late String refreshToken;

  @override
  Future<Response> authorize(AuthRequest authRequest, ManagedContext context,
      Oauth2Api oauth2api) async {
    try {
      final Tokeninfo tokeninfo = await oauth2api.tokeninfo(
        accessToken: authRequest.accessToken,
        idToken: authRequest.idToken,
      );
      final query = Query<User>(
        context,
      );

      final findUser = query..where((x) => x.userId).equalTo(tokeninfo.userId);

      final userData = await findUser.fetchOne();

      final String jwtSecretKey = EnvironmentConstants.jwtSecretKey;

      if (userData == null) {
        final createUser = query
          ..values.userId = tokeninfo.userId
          ..values.email = tokeninfo.email;

        final user = await createUser.insert();

        await _updateToken(user.id ?? 0, context, jwtSecretKey);

        final response = UserAuthResponse(
          userId: user.userId ?? '',
          email: user.email ?? '',
          refreshToken: refreshToken,
          accessToken: accessToken,
        );

        return Response.ok(response.toJson());
      }

      await _updateToken(userData.id ?? 0, context, jwtSecretKey);

      final response = UserAuthResponse(
        userId: userData.userId ?? '',
        email: userData.email ?? '',
        refreshToken: refreshToken,
        accessToken: accessToken,
      );

      return Response.ok(response.toJson());
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    }
  }

  Future<void> _updateToken(
      int userId, ManagedContext transaction, String jwtSecretKey) async {
    refreshToken = _getRefreshToken(jwtSecretKey, userId);

    final qUpdateTokens = Query<User>(transaction)
      ..values.refreshToken = refreshToken
      ..where((x) => x.id).equalTo(userId);

    await qUpdateTokens.updateOne();

    accessToken = _getAccessToken(jwtSecretKey, userId);
  }

  String _getAccessToken(String secretKey, int userId,
      {Duration duration = const Duration(hours: 1)}) {
    final accessClaimSet =
        JwtClaim(maxAge: duration, otherClaims: {'id': userId});
    return issueJwtHS256(accessClaimSet, secretKey);
  }

  String _getRefreshToken(String secretKey, int userId) {
    final refreshClaimSet =
        JwtClaim(maxAge: const Duration(days: 60), otherClaims: {'id': userId});
    return issueJwtHS256(refreshClaimSet, secretKey);
  }
}
