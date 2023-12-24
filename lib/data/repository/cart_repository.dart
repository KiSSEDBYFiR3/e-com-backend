import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:ecom_backend/data/model/cart.dart';
import 'package:ecom_backend/data/model/cart_product.dart';
import 'package:ecom_backend/data/model/cart_response_dto.dart';
import 'package:ecom_backend/data/model/product_model_dto.dart';
import 'package:ecom_backend/data/model/user.dart';
import 'package:ecom_backend/domain/repository/cart_repository.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/app_error_response.dart';
import 'package:ecom_backend/util/external_urls.dart';

class CartRepository implements ICartRepository {
  const CartRepository({required this.dio});

  final Dio dio;

  @override
  Future<CartResponseDto> addToCart(
      {required ManagedContext context,
      required String userId,
      required int id}) async {
    try {
      final productResponse = await dio.get('${Url.products}/$id');

      if (productResponse.data == null) {
        throw AppResponse.notFound(title: 'product not found');
      }
      final json = productResponse.data as Map<String, dynamic>;
      final product = ProductModelDto.fromJson(json);

      final response = await context.transaction<Cart>((transaction) async {
        final userQuery = Query<User>(transaction)
          ..where((x) => x.userId).equalTo(userId);

        final user = await userQuery.fetchOne();
        if (user == null) {
          throw Exception('User not found');
        }

        final queryCart = Query<Cart>(transaction)
          ..where((x) => x.user?.id).equalTo(user.id);

        final cart = await queryCart.fetchOne();

        if (cart == null) {
          throw AppResponse.serverError('Unexpected Error');
        }

        final queryCartProduct = Query<CartProduct>(transaction)
          ..values.productId = id
          ..values.cart = cart
          ..values.description = product.description
          ..values.category = product.category
          ..values.price = product.price?.toString()
          ..values.title = product.title
          ..values.image = product.image;

        await queryCartProduct.insert();

        final updatedCartProductsQuery = Query<CartProduct>(transaction)
          ..where((x) => x.cart?.id).equalTo(cart.id);

        final updatedCartProducts = await updatedCartProductsQuery.fetch();

        // join method by unknown reasons returns list of only one related object, so we have what we have
        cart.products = ManagedSet.from(updatedCartProducts);

        return cart;
      });

      if (response == null) {
        throw AppResponse.serverError('Unexpected Error');
      }

      return _mapCartToCartResponse(response);
    } on DioException catch (_) {
      rethrow;
    } on QueryException catch (_) {
      rethrow;
    }
  }

  @override
  Future<CartResponseDto> deleteFromCart(
      {required ManagedContext context,
      required String userId,
      required int id}) async {
    try {
      final response = await context.transaction((transaction) async {
        final queryCart = Query<Cart>(transaction)
          ..where((x) => x.user?.userId).equalTo(userId);

        final cart = await queryCart.fetchOne();

        if (cart == null) {
          throw AppResponse.serverError('Unexpected Error');
        }

        final queryCartProduct = Query<CartProduct>(transaction)
          ..where((x) => x.cart?.id).equalTo(cart.id)
          ..where((x) => x.id).equalTo(id);

        await queryCartProduct.delete();

        final updatedCartProductsQuery = Query<CartProduct>(transaction)
          ..where((x) => x.cart?.id).equalTo(cart.id);

        final updatedCartProducts = await updatedCartProductsQuery.fetch();

        // join method by unknown reasons returns list of only one related object, so we have what we have
        cart.products = ManagedSet.from(updatedCartProducts);

        return cart;
      });

      if (response == null) {
        throw AppResponse.serverError('Unexpected Error');
      }

      return _mapCartToCartResponse(response);
    } on QueryException catch (e) {
      throw AppResponse.serverError(e.message);
    }
  }

  @override
  Future<CartResponseDto> getCart(
      {required ManagedContext context, required String userId}) async {
    try {
      final response = await context.transaction((transaction) async {
        final queryCart = Query<Cart>(transaction)
          ..where((x) => x.user?.userId).equalTo(userId);

        final cart = await queryCart.fetchOne();

        if (cart == null) {
          throw AppResponse.serverError('Unexpected Error');
        }

        return cart;
      });

      if (response == null) {
        throw AppResponse.serverError('Unexpected Error');
      }

      return _mapCartToCartResponse(response);
    } on QueryException catch (e) {
      throw AppResponse.serverError(e.message);
    }
  }
}

String _calculatePrice(List<CartProduct> products) {
  Decimal price = Decimal.zero;

  for (var index = 0; index < products.length; index++) {
    final product = products[index];
    final productPrice =
        Decimal.fromInt(double.parse(product.price ?? '0').toInt());
    price += productPrice;
  }
  return price.toString();
}

ProductModelDto _mapCartProductToDto(CartProduct products) {
  return ProductModelDto(
    id: products.id,
    category: products.category,
    description: products.description,
    image: products.image,
    price: num.parse(products.price ?? '0'),
    title: products.title,
  );
}

CartResponseDto _mapCartToCartResponse(Cart cart) {
  return CartResponseDto(
    id: cart.id,
    price:
        cart.products != null ? _calculatePrice(cart.products!.toList()) : '0',
    products: cart.products?.map(_mapCartProductToDto).toList() ?? [],
  );
}
