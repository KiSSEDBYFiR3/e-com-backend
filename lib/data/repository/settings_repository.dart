import 'package:soc_backend/data/model/settings.dart';
import 'package:soc_backend/data/model/settings_request.dart';
import 'package:soc_backend/domain/repository/settings_repository.dart';
import 'package:soc_backend/soc_backend.dart';

class SettingRepository implements ISettingsRepository {
  @override
  Future<Settings?> getSettings(String userId, ManagedContext context) async {
    final query = Query<Settings>(context)..where((x) => x.id).equalTo(userId);

    try {
      final settings = await query.fetchOne();
      return settings;
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<Settings?> updateSettings(
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
      return settings;
    } on QueryException catch (_) {
      rethrow;
    }
  }
}
