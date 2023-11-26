import 'package:soc_backend/data/model/saves.dart';
import 'package:soc_backend/data/model/saves_request.dart';
import 'package:soc_backend/soc_backend.dart';

abstract interface class ISavesRepository {
  Future<List<Save>> getSaves(String userId, ManagedContext context);

  Future<Save?> save(
      SavesRequest savesRequest, String userId, ManagedContext context);
}
