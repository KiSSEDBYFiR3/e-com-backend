import 'package:ecom_backend/data/model/product_model_dto.dart';
import 'package:ecom_backend/ecom_backend.dart';

abstract interface class IProductsRepository {
  Future<List<ProductModelDto>> getAllProducts();
}
