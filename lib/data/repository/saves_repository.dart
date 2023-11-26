import 'package:soc_backend/data/model/saves.dart';
import 'package:soc_backend/data/model/saves_request.dart';
import 'package:soc_backend/domain/repository/saves_repository.dart';
import 'package:soc_backend/soc_backend.dart';

class SavesRepository implements ISavesRepository {
  @override
  Future<List<Save>> getSaves(String userId, ManagedContext context) async {
    try {
      final query = Query<Save>(context)
        ..where((x) => x.userId).equalTo(userId);
      final saves = await query.fetch();

      return saves;
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<Save?> save(
    SavesRequest savesRequest,
    String userId,
    ManagedContext context,
  ) async {
    try {
      final query = Query<Save>(context)
        ..where((x) => x.userId).equalTo(userId)
        ..where((x) => x.id).equalTo(savesRequest.id)
        ..values.savedPageNum = savesRequest.savedPageNum
        ..values.batchId = savesRequest.batchId
        ..values;
      final save = await query.updateOne();
      return save;
    } on QueryException catch (_) {
      rethrow;
    }
  }
}
