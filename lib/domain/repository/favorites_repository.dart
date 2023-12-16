import 'package:conduit_core/conduit_core.dart';
import 'package:ecom_backend/data/model/favorite_model.dart';

abstract interface class IFavoritesRepository {
  Future<List<FavoriteProduct>> addToFavorites({
    required int id,
    required String userId,
    required ManagedContext context,
  });
  Future<List<FavoriteProduct>> deleteFromFavorites({
    required int id,
    required String userId,
    required ManagedContext context,
  });

  Future<List<FavoriteProduct>> getFavorites({
    required String userId,
    required ManagedContext context,
  });
}
