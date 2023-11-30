import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:soc_backend/data/model/auth_request.dart';
import 'package:soc_backend/data/model/auth_response.dart';
import 'package:soc_backend/data/model/settings.dart';
import 'package:soc_backend/data/model/token_info.dart';
import 'package:soc_backend/data/model/user.dart';
import 'package:soc_backend/domain/repository/auth_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/env_constants.dart';
import 'package:soc_backend/core/exception/user_not_found.dart';

class AuthRepository implements IAuthRepository {
  late String accessToken;
  late String refreshToken;

  @override
  Future<UserAuthResponse> authorize(
      AuthRequest authRequest, ManagedContext context) async {
    try {
      final jsonTokenInfo = JwtDecoder.decode(authRequest.idToken);

      final tokenInfo = TokenInfo.fromJson(jsonTokenInfo);

      final response =
          await context.transaction<UserAuthResponse>((transaction) async {
        final query = Query<User>(
          transaction,
        );

        final findUser = query..where((x) => x.userId).equalTo(tokenInfo.sub);

        final userData = await findUser.fetchOne();

        final String jwtSecretKey = EnvironmentConstants.jwtSecretKey;

        await _updateToken(tokenInfo.sub, transaction, jwtSecretKey);

        if (userData == null) {
          final createUser = query
            ..values.email = tokenInfo.email
            ..values.name = tokenInfo.name
            ..values.userId = tokenInfo.sub
            ..values.refreshToken = refreshToken;

          final user = await createUser.insert();

          final settingsQuery = Query<Settings>(transaction)
            ..values.user = user
            ..values.volumeLevel = 100
            ..values.staticText = true
            ..values.textGrowthSpeed = 0.5
            ..values.pagesChangeEffect = 'normal'
            ..values.dialoguesWindowType = 'adventure';

          await settingsQuery.insert();

          final response = UserAuthResponse(
            userId: user.userId ?? '',
            id: user.id ?? 0,
            email: user.email ?? '',
            refreshToken: refreshToken,
            accessToken: accessToken,
          );

          return response;
        }

        await _updateToken(userData.userId ?? '', transaction, jwtSecretKey);

        final response = UserAuthResponse(
          id: userData.id ?? 0,
          userId: userData.userId ?? '',
          email: userData.email ?? '',
          refreshToken: refreshToken,
          accessToken: accessToken,
        );
        return response;
      });
      if (response == null) {
        throw Exception();
      }
      return response;
    } on QueryException catch (_) {
      print(_);
      rethrow;
    }
  }

  Future<void> _updateToken(
      String userId, ManagedContext transaction, String jwtSecretKey) async {
    refreshToken = _getRefreshToken(jwtSecretKey, userId);

    final qUpdateTokens = Query<User>(transaction)
      ..values.refreshToken = refreshToken
      ..where((x) => x.userId).equalTo(userId);

    await qUpdateTokens.updateOne();

    accessToken = _getAccessToken(jwtSecretKey, userId);
  }

  String _getAccessToken(String secretKey, String userId,
      {Duration duration = const Duration(hours: 1)}) {
    final accessClaimSet =
        JwtClaim(maxAge: duration, otherClaims: {'id': userId});
    return issueJwtHS256(accessClaimSet, secretKey);
  }

  String _getRefreshToken(String secretKey, String userId) {
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

      await _updateToken(user.userId!, context, jwtSecretKey);

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
