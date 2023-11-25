import 'package:soc_backend/data/model/saves_request.dart';
import 'package:soc_backend/soc_backend.dart';

abstract interface class ISavesRepository {
  Future<Response> getSaves(String userId, ManagedContext context);

  Future<Response> save(
      SavesRequest savesRequest, String userId, ManagedContext context);
}
