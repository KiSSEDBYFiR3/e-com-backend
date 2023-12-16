import 'package:ecom_backend/data/model/auth_request.dart';
import 'package:ecom_backend/data/model/auth_response.dart';
import 'package:ecom_backend/ecom_backend.dart';

abstract interface class IAuthRepository {
  Future<UserAuthResponse> authorize(
      AuthRequest authRequest, ManagedContext context, String uuid);

  Future<UserAuthResponse> updateFreeToken(
      String token, ManagedContext context, String uuid);
}
