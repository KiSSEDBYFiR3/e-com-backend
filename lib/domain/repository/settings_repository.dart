import 'package:soc_backend/data/model/settings.dart';
import 'package:soc_backend/data/model/settings_request.dart';
import 'package:soc_backend/soc_backend.dart';

abstract interface class ISettingsRepository {
  Future<Settings?> updateSettings(
    SettingsRequest settingsRequest,
    String userId,
    ManagedContext context,
  );

  Future<Settings?> getSettings(
    String userId,
    ManagedContext context,
  );
}
