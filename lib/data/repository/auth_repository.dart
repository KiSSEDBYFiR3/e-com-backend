import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:soc_backend/data/model/auth_request.dart';
import 'package:soc_backend/data/model/auth_response.dart';
import 'package:soc_backend/data/model/token_info.dart';
import 'package:soc_backend/data/model/user.dart';
import 'package:soc_backend/domain/repository/auth_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/env_constants.dart';
import 'package:soc_backend/util/user_not_found.dart';

class AuthRepository implements IAuthRepository {
  late String accessToken;
  late String refreshToken;

  @override
  Future<UserAuthResponse> authorize(
      AuthRequest authRequest, ManagedContext context) async {
    try {
      final jsonTokenInfo = JwtDecoder.decode(authRequest.idToken);

      final tokenInfo = TokenInfo.fromJson(jsonTokenInfo);
      final query = Query<User>(
        context,
      );

      final findUser = query..where((x) => x.userId).equalTo(tokenInfo.sub);

      final userData = await findUser.fetchOne();

      final String jwtSecretKey = EnvironmentConstants.jwtSecretKey;

      if (userData == null) {
        final createUser = query..values.email = tokenInfo.email;

        final user = await createUser.insert();

        await _updateToken(user.id ?? 0, context, jwtSecretKey);

        final response = UserAuthResponse(
          userId: user.userId ?? '',
          id: user.id ?? 0,
          email: user.email ?? '',
          refreshToken: refreshToken,
          accessToken: accessToken,
        );

        return response;
      }

      await _updateToken(userData.id ?? 0, context, jwtSecretKey);

      final response = UserAuthResponse(
        id: userData.id ?? 0,
        userId: userData.userId ?? '',
        email: userData.email ?? '',
        refreshToken: refreshToken,
        accessToken: accessToken,
      );

      return response;
    } on QueryException catch (_) {
      print(_);
      rethrow;
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

  @override
  Future<UserAuthResponse> updateFreeToken(
      String token, ManagedContext context) async {
    try {
      final jwtSecretKey = EnvironmentConstants.jwtSecretKey;
      final jwtToken = verifyJwtHS256Signature(token, jwtSecretKey);
      jwtToken.validate();

      final id = int.parse(jwtToken['id'].toString());

      final user = await (Query<User>(context)..where((x) => x.id).equalTo(id))
          .fetchOne();

      if (user == null) {
        throw UserNotFound();
      }

      await _updateToken(user.id!, context, jwtSecretKey);

      return UserAuthResponse(
        userId: user.userId ?? '',
        id: user.id ?? 0,
        email: user.email ?? '',
        refreshToken: refreshToken,
        accessToken: accessToken,
      );
    } on JwtException catch (_) {
      rethrow;
    }
  }
}
