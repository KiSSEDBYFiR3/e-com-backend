import 'package:conduit_core/src/db/managed/context.dart';
import 'package:conduit_core/src/http/response.dart';
import 'package:soc_backend/data/model/settings.dart';
import 'package:soc_backend/data/model/settings_request.dart';
import 'package:soc_backend/domain/repository/settings_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';

class SettingRepository implements ISettingsRepository {
  @override
  Future<Response> getSettings(String userId, ManagedContext context) async {
    final query = Query<Settings>(context)..where((x) => x.id).equalTo(userId);

    try {
      final settings = await query.fetchOne();
      if (settings == null) {
        return AppResponse.notFound();
      }
      return Response.ok(settings.toJson());
    } on QueryException catch (e) {
      throw AppResponse.serverError(e, message: e.message);
    }
  }

  @override
  Future<Response> updateSettings(
    SettingsRequest settingsRequest,
    String userId,
    ManagedContext context,
  ) async {
    try {
      final query = Query<Settings>(context)
        ..where((x) => x.id).equalTo(userId)
        ..values.dialoguesWindowType = settingsRequest.dialoguesWindowType
        ..values.pagesChangeEffect = settingsRequest.pagesChangeEffect
        ..values.staticText = settingsRequest.staticText
        ..values.textGrowthSpeed = settingsRequest.textGrowthSpeed
        ..values.volumeLevel = settingsRequest.volumeLevel;

      final settings = await query.updateOne();
      if (settings == null) {
        return AppResponse.badRequest();
      }

      return Response.ok(settings.toJson());
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    }
  }
}
