import 'package:conduit_core/conduit_core.dart';

import 'package:ecom_backend/data/model/cart.dart';
import 'package:ecom_backend/data/model/cart_product.dart';
import 'package:ecom_backend/domain/repository/order_repository.dart';
import 'package:ecom_backend/util/app_error_response.dart';

class OrderRepository implements IOrderRepository {
  @override
  Future<String> createOrder(
      {required ManagedContext context, required String userId}) async {
    try {
      await context.transaction(
        (transaction) async {
          final query = Query<Cart>(transaction)
            ..where((x) => x.user?.userId).equalTo(userId);

          final cart = await query.fetchOne();

          if (cart == null) {
            throw AppResponse.badRequest();
          }

          final cartProductsQuery = Query<CartProduct>(transaction)
            ..where((x) => x.cart?.id).equalTo(cart.id);

          final count = await cartProductsQuery.delete();
          print(count);
        },
      );
      return 'success';
    } on QueryException catch (_) {
      rethrow;
    }
  }
}
