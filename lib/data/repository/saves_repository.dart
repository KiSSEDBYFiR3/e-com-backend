import 'package:conduit_core/src/db/managed/context.dart';
import 'package:conduit_core/src/http/response.dart';
import 'package:soc_backend/data/model/saves.dart';
import 'package:soc_backend/data/model/saves_request.dart';
import 'package:soc_backend/data/model/saves_response.dart';
import 'package:soc_backend/domain/repository/saves_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';

class SavesRepository implements ISavesRepository {
  @override
  Future<Response> getSaves(String userId, ManagedContext context) async {
    try {
      final query = Query<Save>(context)
        ..where((x) => x.userId).equalTo(userId);
      final saves = await query.fetch();

      return Response.ok(SavesResponse(saves).toJson());
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    }
  }

  @override
  Future<Response> save(
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
      if (save == null) {
        return AppResponse.badRequest();
      }
      return Response.ok(save.toJson());
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    }
  }
}
