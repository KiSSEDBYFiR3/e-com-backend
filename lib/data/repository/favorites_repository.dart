import 'package:conduit_core/conduit_core.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:ecom_backend/data/model/favorite_model.dart';
import 'package:ecom_backend/data/model/product_model_dto.dart';
import 'package:ecom_backend/data/model/user.dart';
import 'package:ecom_backend/domain/repository/favorites_repository.dart';
import 'package:ecom_backend/util/app_error_response.dart';

import '../../util/external_urls.dart';

class FavoritesRepository implements IFavoritesRepository {
  const FavoritesRepository({required this.dio});
  final Dio dio;

  @override
  Future<List<ProductModelDto>> addToFavorites({
    required int id,
    required String userId,
    required ManagedContext context,
  }) async {
    try {
      final productResponse = await dio.get('${Url.products}/$id');

      if (productResponse.data == null) {
        throw AppResponse.notFound(title: 'product not found');
      }
      final json = productResponse.data as Map<String, dynamic>;

      final product = ProductModelDto.fromJson(json);

      final favorites = await context.transaction(
        (transaction) async {
          final userQuery = Query<User>(transaction)
            ..where((x) => x.userId).equalTo(userId);
          final user = await userQuery.fetchOne();

          if (user == null) {
            throw AppResponse.badRequest();
          }

          final query = Query<FavoriteProduct>(transaction)
            ..where((x) => x.user?.id).equalTo(user.id);

          final insertQuery = query
            ..values.category = product.category
            ..values.productId = product.id
            ..values.image = product.image
            ..values.price = product.price?.toString()
            ..values.description = product.description
            ..values.title = product.title
            ..values.user = user;

          await insertQuery.insert();

          final favoritesQuery = Query<FavoriteProduct>(context)
            ..where((x) => x.user?.id).equalTo(user.id);

          final favorites = await favoritesQuery.fetch();

          return favorites.map(_mapFavoritesProductToDto).toList();
        },
      );

      return favorites ?? [];
    } on DioException catch (_) {
      rethrow;
    } on QueryException catch (_) {
      rethrow;
    }
  }

  ProductModelDto _mapFavoritesProductToDto(FavoriteProduct products) {
    return ProductModelDto(
      id: products.productId,
      category: products.category,
      description: products.description,
      image: products.image,
      price: double.parse(products.price ?? '0'),
      title: products.title,
    );
  }

  @override
  Future<List<ProductModelDto>> deleteFromFavorites(
      {required int id,
      required String userId,
      required ManagedContext context}) async {
    try {
      final favorites = await context.transaction((transaction) async {
        final userQuery = Query<User>(transaction)
          ..where((x) => x.userId).equalTo(userId);
        final user = await userQuery.fetchOne();

        if (user == null) {
          throw AppResponse.badRequest();
        }
        final query = Query<FavoriteProduct>(transaction)
          ..where((x) => x.user?.id).equalTo(user.id);

        final deleteQuery = query..where((x) => x.productId).equalTo(id);

        await deleteQuery.delete();

        final favoritesQuery = Query<FavoriteProduct>(context)
          ..where((x) => x.user?.id).equalTo(user.id);

        final favorites = await favoritesQuery.fetch();

        return favorites.map(_mapFavoritesProductToDto).toList();
      });

      return favorites ?? [];
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ProductModelDto>> getFavorites(
      {required String userId, required ManagedContext context}) async {
    try {
      final favorites = await context.transaction(
        (transaction) async {
          final query = Query<User>(transaction)
            ..where((x) => x.userId).equalTo(userId)
            ..join(set: (x) => x.favorites);

          final userWithFavorites = await query.fetchOne();

          return userWithFavorites?.favorites;
        },
      );

      return favorites?.map(_mapFavoritesProductToDto).toList() ?? [];
    } on QueryException catch (_) {
      rethrow;
    }
  }
}
