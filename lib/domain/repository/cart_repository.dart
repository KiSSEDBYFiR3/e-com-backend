import 'package:ecom_backend/data/model/cart.dart';
import 'package:ecom_backend/ecom_backend.dart';

abstract interface class ICartRepository {
  Future<Cart> addToCart(
      {required ManagedContext context,
      required String userId,
      required int id});

  Future<Cart> deleteFromCart(
      {required ManagedContext context,
      required String userId,
      required int id});

  Future<Cart> getCart({
    required ManagedContext context,
    required String userId,
  });
}
