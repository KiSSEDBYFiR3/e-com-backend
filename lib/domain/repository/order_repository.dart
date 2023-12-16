import 'package:conduit_core/conduit_core.dart';

abstract interface class IOrderRepository {
  Future<String> createOrder(
      {required ManagedContext context, required String userId});
}
