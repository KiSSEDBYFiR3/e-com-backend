import 'package:soc_backend/data/model/saves.dart';
import 'package:soc_backend/data/model/saves_request.dart';
import 'package:soc_backend/domain/repository/saves_repository.dart';
import 'package:soc_backend/soc_backend.dart';

class SavesRepository implements ISavesRepository {
  @override
  Future<List<Save>> getSaves(String userId, ManagedContext context) async {
    try {
      final query = Query<Save>(context)
        ..where((x) => x.user?.userId).equalTo(userId);
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
      final saveQuery = Query<Save>(context)
        ..where((x) => x.user?.userId).equalTo(userId)
        ..where((x) => x.id == savesRequest.id)
        ..values.batchId = savesRequest.batchId
        ..values.savedPageNum = savesRequest.savedPageNum;

      final save = await saveQuery.updateOne();
      return save;
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<Save?> createSave(
      SavesRequest savesRequest, ManagedContext context) async {
    try {
      final saveQuery = Query<Save>(context)
        ..values.batchId = savesRequest.batchId
        ..values.savedPageNum = savesRequest.savedPageNum
        ..values.user?.id = savesRequest.id;

      final save = await saveQuery.insert();
      return save;
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSave(
      SavesRequest savesRequest, String userId, ManagedContext context) async {
    try {
      final saveQuery = Query<Save>(context)
        ..where((x) => x.user?.userId).equalTo(userId)
        ..where((x) => x.id).equalTo(savesRequest.id);

      await saveQuery.delete();
    } on QueryException catch (_) {
      rethrow;
    }
  }
}
