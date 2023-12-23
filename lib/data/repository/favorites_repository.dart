import 'dart:convert';
import 'dart:isolate';

import 'package:conduit_core/conduit_core.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:ecom_backend/data/model/favorite_model.dart';
import 'package:ecom_backend/data/model/product_model_dto.dart';
import 'package:ecom_backend/domain/repository/favorites_repository.dart';
import 'package:ecom_backend/util/app_error_response.dart';

import '../../util/external_urls.dart';

class FavoritesRepository implements IFavoritesRepository {
  const FavoritesRepository({required this.dio});
  final Dio dio;

  @override
  Future<List<FavoriteProduct>> addToFavorites({
    required int id,
    required String userId,
    required ManagedContext context,
  }) async {
    try {
      final productResponse = await dio.get('${Url.products}/$id');

      if (productResponse.data == null) {
        throw AppResponse.notFound(title: 'product not found');
      }
      final json = await Isolate.run(() => jsonDecode(productResponse.data));

      final product = ProductModelDto.fromJson(json);

      final favorites = await context.transaction((transaction) async {
        final query = Query<FavoriteProduct>(transaction)
          ..where(
            (x) => x.user?.userId == userId,
          );

        final insertQuery = query
          ..values.category = product.category
          ..values.id = product.id
          ..values.image = product.image
          ..values.price = product.price
          ..values.description = product.description
          ..values.title = product.title;

        await insertQuery.insert();

        final products = await query.fetch();
        return products;
      });

      return favorites ?? [];
    } on DioException catch (_) {
      rethrow;
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<FavoriteProduct>> deleteFromFavorites(
      {required int id,
      required String userId,
      required ManagedContext context}) async {
    try {
      final favorites = await context.transaction((transaction) async {
        final query = Query<FavoriteProduct>(transaction)
          ..where((x) => x.user?.userId == userId);

        final deleteQuery = query
          ..where(
            (x) => x.id == id,
          );

        await deleteQuery.delete();

        final favorites = await query.fetch();
        return favorites;
      });

      return favorites ?? [];
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<FavoriteProduct>> getFavorites(
      {required String userId, required ManagedContext context}) async {
    try {
      final query = Query<FavoriteProduct>(context)
        ..where((x) => x.user?.userId == userId);
      final favorites = await query.fetch();

      return favorites ?? [];
    } on QueryException catch (_) {
      rethrow;
    }
  }
}
