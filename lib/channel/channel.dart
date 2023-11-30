import 'dart:developer' as dev;

import 'package:conduit_postgresql/conduit_postgresql.dart';
import 'package:googleapis/oauth2/v2.dart';
import 'package:soc_backend/core/di/di.dart';
import 'package:soc_backend/core/exception/db_configuration_exception.dart';
import 'package:soc_backend/core/init_service_locator.dart';
import 'package:soc_backend/data/controllers/api_docs_controller.dart';
import 'package:soc_backend/data/controllers/auth_controller.dart';
import 'package:soc_backend/data/controllers/auth_free_token_controller.dart';
import 'package:soc_backend/data/controllers/auth_middleware_controller.dart';
import 'package:soc_backend/data/controllers/pages_controller.dart';
import 'package:soc_backend/data/controllers/saves_controller.dart';
import 'package:soc_backend/data/controllers/settings_controller.dart';
import 'package:soc_backend/data/repository/auth_repository.dart';
import 'package:soc_backend/domain/repository/auth_repository.dart';
import 'package:soc_backend/domain/repository/pages_repository.dart';
import 'package:soc_backend/domain/repository/saves_repository.dart';
import 'package:soc_backend/domain/repository/settings_repository.dart';
import 'package:soc_backend/soc_backend.dart' hide AuthController;
import 'package:soc_backend/util/env_constants.dart';
import 'package:soc_backend/util/routes.dart';
import 'package:yaml/yaml.dart';

class SocBackendChannel extends ApplicationChannel {
  late final ManagedContext context;
  late final ServiceLocator sl;
  @override
  Future prepare() async {
    ServiceLocator.init();
    sl = ServiceLocator.instance;

    registerServices(sl);

    final postgresDB = await _configureDB();

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

    context = ManagedContext(dataModel, postgresDB);

    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    router
      ..route(Routes.auth).link(
        () => AuthorizationController(
          context,
          sl.getObject(IAuthRepository),
        ),
      )
      ..route(Routes.freeToken).link(
          () => AuthFreeTokenController(context, sl.getObject(IAuthRepository)))
      ..route(Routes.pages)
          .link(AuthMiddlewareController.new)
          ?.link(() => PagesController(context, sl.getObject(IPagesRepository)))
      ..route(Routes.settings).link(AuthMiddlewareController.new)?.link(
          () => SettingsController(context, sl.getObject(ISettingsRepository)))
      ..route(Routes.saves)
          .link(AuthMiddlewareController.new)
          ?.link(() => SavesController(context, sl.getObject(ISavesRepository)))
      ..route(Routes.docs).link(() => FileController(Directory.current.path));

    return router;
  }

  Future<PersistentStore> _configureDB() async {
    try {
      final configFile = await File('config.yaml').readAsString();
      final yaml = loadYaml(configFile);

      final fail = (String msg) =>
          throw Exception("The DB configuration was skipped. ($msg)");
      final getYamlKey =
          (String key) => yaml != null ? yaml[key].toString() : null;

      final username = EnvironmentConstants.dbUsername ??
          getYamlKey('username') ??
          fail("DB_USERNAME | username");

      final password = EnvironmentConstants.dbPassword ??
          getYamlKey('password') ??
          fail("DB_PASSWORD | password");

      final host =
          EnvironmentConstants.dbHost ?? getYamlKey('host') ?? 'postgres';

      final port = int.parse(
          EnvironmentConstants.dbPort ?? getYamlKey('port') ?? '5432');

      final databaseName = EnvironmentConstants.dbName ??
          getYamlKey('databaseName') ??
          fail("DB_NAME | databaseName");

      return PostgreSQLPersistentStore.fromConnectionInfo(
        username,
        password,
        host,
        port,
        databaseName,
      );
    } catch (e) {
      dev.log(e.toString());
      throw DBConfigurationException(e.toString());
    }
  }
}
