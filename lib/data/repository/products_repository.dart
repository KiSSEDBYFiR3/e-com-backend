import 'dart:isolate';

import 'package:dio/dio.dart' hide Response;
import 'package:ecom_backend/data/model/product_model_dto.dart';
import 'package:ecom_backend/domain/repository/products_repository.dart';
import 'package:ecom_backend/util/app_error_response.dart';
import 'package:ecom_backend/util/external_urls.dart';
import 'package:ecom_backend/util/json.dart';

class ProductRepository implements IProductsRepository {
  const ProductRepository({
    required this.dio,
  });
  final Dio dio;

  @override
  Future<List<ProductModelDto>> getAllProducts() async {
    try {
      final productsResponse = await dio.get<List<dynamic>>(Url.products);
      if (productsResponse.data == null) {
        throw AppResponse.notFound();
      }
      final productsList = await Isolate.run(() =>
          _deserializeListProductModelDto(
              productsResponse.data!.cast<Map<String, dynamic>>()));

      return productsList;
    } on DioException catch (_) {
      rethrow;
    }
  }

  List<ProductModelDto> _deserializeListProductModelDto(List<Json> json) =>
      json.map(ProductModelDto.fromJson).toList();
}
