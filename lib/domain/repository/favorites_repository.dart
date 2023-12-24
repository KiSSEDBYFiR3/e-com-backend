import 'package:conduit_core/conduit_core.dart';
import 'package:ecom_backend/data/model/product_model_dto.dart';

abstract interface class IFavoritesRepository {
  Future<List<ProductModelDto>> addToFavorites({
    required int id,
    required String userId,
    required ManagedContext context,
  });
  Future<List<ProductModelDto>> deleteFromFavorites({
    required int id,
    required String userId,
    required ManagedContext context,
  });

  Future<List<ProductModelDto>> getFavorites({
    required String userId,
    required ManagedContext context,
  });
}
