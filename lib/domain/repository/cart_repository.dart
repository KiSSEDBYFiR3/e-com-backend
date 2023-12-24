import 'package:ecom_backend/data/model/cart_response_dto.dart';
import 'package:ecom_backend/ecom_backend.dart';

abstract interface class ICartRepository {
  Future<CartResponseDto> addToCart(
      {required ManagedContext context,
      required String userId,
      required int id});

  Future<CartResponseDto> deleteFromCart(
      {required ManagedContext context,
      required String userId,
      required int id});

  Future<CartResponseDto> getCart({
    required ManagedContext context,
    required String userId,
  });
}
