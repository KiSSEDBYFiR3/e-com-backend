import 'dart:developer' as dev;

import 'package:conduit_postgresql/conduit_postgresql.dart';
import 'package:ecom_backend/core/di/di.dart';
import 'package:ecom_backend/core/di/init_service_locator.dart';
import 'package:ecom_backend/core/exception/db_configuration_exception.dart';
import 'package:ecom_backend/data/controllers/auth_controller.dart';
import 'package:ecom_backend/data/controllers/auth_middleware_controller.dart';
import 'package:ecom_backend/data/controllers/auth_token_refresh_controller.dart';
import 'package:ecom_backend/data/controllers/cart_controller.dart';
import 'package:ecom_backend/data/controllers/favorites_controller.dart';
import 'package:ecom_backend/data/controllers/order_controller.dart';
import 'package:ecom_backend/data/controllers/products_controller.dart';
import 'package:ecom_backend/domain/repository/auth_repository.dart';
import 'package:ecom_backend/domain/repository/cart_repository.dart';
import 'package:ecom_backend/domain/repository/favorites_repository.dart';
import 'package:ecom_backend/domain/repository/order_repository.dart';
import 'package:ecom_backend/domain/repository/products_repository.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/env_constants.dart';
import 'package:ecom_backend/util/routes.dart';
import 'package:yaml/yaml.dart';

class EcomBackendChannel extends ApplicationChannel {
  late final ManagedContext context;
  late final ServiceLocator sl;
  @override
  Future prepare() async {
    ServiceLocator.init();
    sl = ServiceLocator.instance;

    CORSPolicy.defaultPolicy
      ..allowedOrigins = ['*']
      ..allowedRequestHeaders.addAll([
        'Uuid',
        'Referer',
        'Authorization',
        'User-Agent',
        'Content-Type',
      ])
      ..allowedMethods.add('OPTIONS');

    registerServices(sl);

    final postgresDB = await _configureDB();

    await postgresDB.getDatabaseConnection();

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

    context = ManagedContext(dataModel, postgresDB);

    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = ORouter();

    router
      ..route(Routes.auth).link(
        () => AuthorizationController(
          context,
          sl.getObject(IAuthRepository),
        ),
      )
      ..route(Routes.refresh).link(
        () => AuthRefreshTokenController(
          context,
          sl.getObject(IAuthRepository),
        ),
      )
      ..route(Routes.favorites).link(AuthMiddlewareController.new)?.link(
            () => FavoritesController(
              context: context,
              repository: sl.getObject(IFavoritesRepository),
            ),
          )
      ..route(Routes.cart).link(AuthMiddlewareController.new)?.link(() {
        return CartController(
          context: context,
          repository: sl.getObject(ICartRepository),
        );
      })
      ..route(Routes.order).link(AuthMiddlewareController.new)?.link(
            () => OrderController(
              context: context,
              repository: sl.getObject(IOrderRepository),
            ),
          )
      ..route(Routes.products).link(AuthMiddlewareController.new)?.link(
            () => ProductsController(
              context: context,
              repository: sl.getObject(IProductsRepository),
            ),
          )
      ..route(Routes.docs).link(
        () => FileController(Directory.current.path),
      );

    return router;
  }

  Future<PostgreSQLPersistentStore> _configureDB() async {
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

class ORouter extends Router {
  @override
  Future receive(Request req) {
    print(req);
    return super.receive(req);
  }
}
