import 'package:googleapis/oauth2/v2.dart';
import 'package:soc_backend/data/model/auth_request.dart';
import 'package:soc_backend/soc_backend.dart';

abstract interface class IAuthRepository {
  Future<Response> authorize(
      AuthRequest authRequest, ManagedContext context, Oauth2Api oauth2api);
}
