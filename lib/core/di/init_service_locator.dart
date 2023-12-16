import 'package:ecom_backend/core/di/di.dart';
import 'package:ecom_backend/core/di/init_dio.dart';
import 'package:ecom_backend/data/repository/auth_repository.dart';
import 'package:ecom_backend/data/repository/cart_repository.dart';
import 'package:ecom_backend/data/repository/favorites_repository.dart';
import 'package:ecom_backend/data/repository/order_repository.dart';
import 'package:ecom_backend/data/repository/products_repository.dart';
import 'package:ecom_backend/domain/repository/auth_repository.dart';
import 'package:ecom_backend/domain/repository/cart_repository.dart';
import 'package:ecom_backend/domain/repository/favorites_repository.dart';
import 'package:ecom_backend/domain/repository/order_repository.dart';
import 'package:ecom_backend/domain/repository/products_repository.dart';

void registerServices(ServiceLocator sl) {
  final _dio = initDio();

  sl.registerSingletone(_dio);
  sl.registerSingltoneAs(IAuthRepository, AuthRepository());
  sl.registerSingltoneAs(IFavoritesRepository, FavoritesRepository(dio: _dio));
  sl.registerSingltoneAs(IProductsRepository, ProductRepository(dio: _dio));
  sl.registerSingltoneAs(ICartRepository, CartRepository(dio: _dio));
  sl.registerSingltoneAs(IOrderRepository, OrderRepository());
}
