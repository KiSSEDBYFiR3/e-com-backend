import 'dart:convert';
import 'dart:isolate';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:ecom_backend/data/model/cart.dart';
import 'package:ecom_backend/data/model/cart_product.dart';
import 'package:ecom_backend/data/model/product_model_dto.dart';
import 'package:ecom_backend/domain/repository/cart_repository.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/app_error_response.dart';
import 'package:ecom_backend/util/external_urls.dart';

class CartRepository implements ICartRepository {
  const CartRepository({required this.dio});

  final Dio dio;

  @override
  Future<Cart> addToCart(
      {required ManagedContext context,
      required String userId,
      required int id}) async {
    try {
      final productResponse = await dio.get('${Url.products}/$id');

      if (productResponse.data == null) {
        throw AppResponse.notFound(title: 'product not found');
      }
      final json = await Isolate.run(() => jsonDecode(productResponse.data));

      final product = ProductModelDto.fromJson(json);

      final response = await context.transaction<Cart>((transaction) async {
        final queryCart = Query<Cart>(transaction)
          ..where((x) => x.user?.userId == userId);

        final cart = await queryCart.fetchOne();

        if (cart == null) {
          throw AppResponse.serverError('Unexpected Error');
        }

        final queryCartProduct = Query<CartProduct>(transaction)
          ..values.cart = cart
          ..values.description = product.description
          ..values.category = product.category
          ..values.price = product.price
          ..values.title = product.title
          ..values.image = product.image;

        await queryCartProduct.insert();

        final newCartPrice =
            Decimal.parse(cart.price) + Decimal.parse(product.price ?? '0');

        final updateCart = queryCart..values.price = newCartPrice.toString();

        final updatedCart = await updateCart.updateOne();

        if (updatedCart == null) {
          throw AppResponse.serverError('Unexpected error');
        }

        return updatedCart;
      });

      if (response == null) {
        throw AppResponse.serverError('Unexpected Error');
      }

      return response;
    } on DioException catch (_) {
      rethrow;
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<Cart> deleteFromCart(
      {required ManagedContext context,
      required String userId,
      required int id}) async {
    try {
      final response = await context.transaction((transaction) async {
        final queryCart = Query<Cart>(transaction)
          ..where((x) => x.user?.userId == userId);

        final cart = await queryCart.fetchOne();

        if (cart == null) {
          throw AppResponse.serverError('Unexpected Error');
        }

        final queryCartProduct = Query<CartProduct>(transaction)
          ..where((x) => x.cart?.id == cart.id)
          ..where((x) => x.id == id);

        final product = await queryCartProduct.fetchOne();

        await queryCartProduct.delete();

        final newCartPrice =
            Decimal.parse(cart.price) + Decimal.parse(product?.price ?? '0');

        final updateCart = queryCart..values.price = newCartPrice.toString();

        final updatedCart = await updateCart.updateOne();

        return updatedCart;
      });

      if (response == null) {
        throw AppResponse.serverError('Unexpected Error');
      }

      return response;
    } on QueryException catch (e) {
      throw AppResponse.serverError(e.message);
    }
  }

  @override
  Future<Cart> getCart(
      {required ManagedContext context, required String userId}) async {
    try {
      final response = await context.transaction((transaction) async {
        final queryCart = Query<Cart>(transaction)
          ..where((x) => x.user?.userId == userId);

        final cart = await queryCart.fetchOne();

        if (cart == null) {
          throw AppResponse.serverError('Unexpected Error');
        }

        return cart;
      });

      if (response == null) {
        throw AppResponse.serverError('Unexpected Error');
      }

      return response;
    } on QueryException catch (e) {
      throw AppResponse.serverError(e.message);
    }
  }
}
