import 'package:soc_backend/data/model/auth_request.dart';
import 'package:soc_backend/data/model/auth_response.dart';
import 'package:soc_backend/soc_backend.dart';

abstract interface class IAuthRepository {
  Future<UserAuthResponse> authorize(
      AuthRequest authRequest, ManagedContext context);

  Future<UserAuthResponse> updateFreeToken(
      String token, ManagedContext context);
}
