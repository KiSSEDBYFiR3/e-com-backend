import 'package:conduit_core/conduit_core.dart';

import 'package:ecom_backend/data/model/cart.dart';
import 'package:ecom_backend/domain/repository/order_repository.dart';

class OrderRepository implements IOrderRepository {
  @override
  Future<String> createOrder(
      {required ManagedContext context, required String userId}) async {
    try {
      final query = Query<Cart>(context)..where((x) => x.user?.userId = userId);
      await query.delete();
      return '';
    } on QueryException catch (_) {
      rethrow;
    }
  }
}
