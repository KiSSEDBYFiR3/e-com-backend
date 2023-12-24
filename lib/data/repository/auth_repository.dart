import 'package:ecom_backend/core/exception/user_not_found.dart';
import 'package:ecom_backend/data/model/auth_response.dart';
import 'package:ecom_backend/data/model/cart.dart';
import 'package:ecom_backend/data/model/user.dart';
import 'package:ecom_backend/domain/repository/auth_repository.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/app_error_response.dart';
import 'package:ecom_backend/util/env_constants.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AuthRepository implements IAuthRepository {
  AuthRepository();

  late String accessToken;
  late String refreshToken;

  @override
  Future<UserAuthResponse> authorize(
      String token, ManagedContext context, String uuid) async {
    try {
      if (token.contains('Bearer')) {
        _bearerValidator(token);
      } else {
        final basicTokenInfo = const AuthorizationBasicParser().parse(token);

        if (basicTokenInfo.username != 'KiSSEDBYFiR3' ||
            basicTokenInfo.password != 'ecomApp') {
          throw AppResponse.forbidden();
        }
      }
      final user = await context.transaction<User>((transaction) async {
        final query = Query<User>(
          transaction,
        );

        print(query.toString());

        final findUser = query..where((x) => x.userId).equalTo(uuid);

        final userData = await findUser.fetchOne();

        print(userData.toString());

        final String jwtSecretKey = EnvironmentConstants.jwtSecretKey;

        if (userData == null) {
          await _updateToken(uuid, transaction, jwtSecretKey);

          final createUser = query
            ..values.userId = uuid
            ..values.refreshToken = refreshToken;

          final user = await createUser.insert();

          print(user);
          final createCart = Query<Cart>(transaction)
            ..values.price = '0'
            ..values.user = user;

          await createCart.insert();

          return user;
        }

        await _updateToken(userData.userId ?? '', transaction, jwtSecretKey);
        return userData;
      });

      if (user == null) {
        throw Exception();
      }

      final response = UserAuthResponse(
        id: user.id ?? 0,
        refreshToken: refreshToken,
        accessToken: accessToken,
      );

      print(response);

      return response;
    } on QueryException catch (_) {
      print(_);
      rethrow;
    }
  }

  void _bearerValidator(String token) {
    final bearer = const AuthorizationBearerParser().parse(token) ?? '';
    final jwtToken =
        verifyJwtHS256Signature(bearer, EnvironmentConstants.jwtSecretKey);
    jwtToken.validate();
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
  Future<UserAuthResponse> tokenRefresh(
      String token, ManagedContext context, String uuid) async {
    try {
      final jwt = const AuthorizationBearerParser().parse(token) ?? '';

      final jwtSecretKey = EnvironmentConstants.jwtSecretKey;

      final jwtToken = verifyJwtHS256Signature(jwt, jwtSecretKey);

      jwtToken.validate();

      final id = jwtToken['id'].toString();

      final user = await (Query<User>(context)
            ..where((x) => x.userId).equalTo(id))
          .fetchOne();

      if (user == null) {
        throw UserNotFound();
      }

      await _updateToken(user.userId!, context, jwtSecretKey);

      return UserAuthResponse(
        id: user.id ?? 0,
        refreshToken: refreshToken,
        accessToken: accessToken,
      );
    } on JwtException catch (_) {
      rethrow;
    }
  }
}
