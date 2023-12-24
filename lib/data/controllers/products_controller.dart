import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:ecom_backend/data/model/product_model_dto.dart';
import 'package:ecom_backend/domain/repository/products_repository.dart';
import 'package:ecom_backend/ecom_backend.dart';
import 'package:ecom_backend/util/app_error_response.dart';

class ProductsController extends ResourceController {
  ProductsController({
    required this.context,
    required this.repository,
  });

  final ManagedContext context;
  final IProductsRepository repository;

  @Operation.get()
  Future<Response> getProducts() async {
    try {
      final products = await repository.getAllProducts();
      return Response.ok(
        products,
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
        APISchemaObject.array(
          ofSchema: const ProductModelDto().documentSchema(context),
        ),
      )
    };
  }
}
