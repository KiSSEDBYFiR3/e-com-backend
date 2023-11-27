import 'package:soc_backend/core/di/di.dart';
import 'package:soc_backend/data/repository/auth_repository.dart';
import 'package:soc_backend/data/repository/pages_repository.dart';
import 'package:soc_backend/data/repository/saves_repository.dart';
import 'package:soc_backend/data/repository/settings_repository.dart';
import 'package:soc_backend/domain/repository/auth_repository.dart';
import 'package:soc_backend/domain/repository/pages_repository.dart';
import 'package:soc_backend/domain/repository/saves_repository.dart';
import 'package:soc_backend/domain/repository/settings_repository.dart';

void registerServices(ServiceLocator sl) {
  sl.registerSingltoneAs(IPagesRepository, PagesRepository());
  sl.registerSingltoneAs(ISavesRepository, SavesRepository());
  sl.registerSingltoneAs(ISettingsRepository, SettingRepository());
  sl.registerSingltoneAs(IAuthRepository, AuthRepository());
}
