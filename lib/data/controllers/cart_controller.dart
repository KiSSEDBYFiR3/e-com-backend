import 'dart:async';
import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:ecom_backend/data/model/cart.dart';
import 'package:ecom_backend/domain/repository/cart_repository.dart';
import 'package:ecom_backend/util/app_error_response.dart';

class CartController extends ResourceController {
  CartController({
    required this.context,
    required this.repository,
  });

  final ManagedContext context;
  final ICartRepository repository;

  @Operation.post('id')
  Future<Response> addToCart() async {
    final userId = request!.attachments['userId'] as String? ?? '';
    final id = request!.raw.requestedUri.queryParameters['id'];
    if (id == null) {
      return AppResponse.badRequest();
    }

    try {
      final cart = await repository.addToCart(
        context: context,
        userId: userId,
        id: int.parse(id),
      );
      return Response.ok(
        cart,
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      logger.severe(e.toString());
      return AppResponse.serverError(e.toString());
    }
  }

  @Operation.delete('id')
  Future<Response> deleteFromCart() async {
    final userId = request!.attachments['userId'] as String;
    final id = request!.raw.requestedUri.queryParameters['id'];
    if (id == null) {
      return AppResponse.badRequest();
    }
    try {
      final cart = await repository.deleteFromCart(
        context: context,
        userId: userId,
        id: int.parse(id),
      );
      return Response.ok(cart);
    } catch (e) {
      logger.severe(e.toString());

      return AppResponse.serverError(e.toString());
    }
  }

  @Operation.get()
  Future<Response> getCart() async {
    final userId = request!.attachments['userId'] as String;

    try {
      final cart = await repository.getCart(
        context: context,
        userId: userId,
      );
      return Response.ok(cart);
    } catch (e) {
      logger.severe(e.toString());

      return AppResponse.serverError(e.toString());
    }
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      '200': APIResponse.schema(
        '',
        Cart().documentSchema(context),
      ),
    };
  }
}
