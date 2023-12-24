import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:ecom_backend/domain/repository/order_repository.dart';
import 'package:ecom_backend/util/app_error_response.dart';

class OrderController extends ResourceController {
  OrderController({
    required this.context,
    required this.repository,
  });

  final IOrderRepository repository;
  final ManagedContext context;

  @Operation.post()
  Future<Response> createOrder() async {
    final userId = request!.attachments['userId'] as String;
    try {
      final response =
          await repository.createOrder(context: context, userId: userId);
      return Response.ok(
        response,
        headers: {"Content-Type": "application/json"},
      );
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
        APISchemaObject.string(),
      )
    };
  }
}
