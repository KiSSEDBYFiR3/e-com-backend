import 'package:ecom_backend/data/model/auth_response.dart';
import 'package:ecom_backend/ecom_backend.dart';

abstract interface class IAuthRepository {
  Future<UserAuthResponse> authorize(
      String token, ManagedContext context, String uuid);

  Future<UserAuthResponse> tokenRefresh(
      String token, ManagedContext context, String uuid);
}
