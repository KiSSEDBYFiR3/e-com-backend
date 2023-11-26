import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/response.dart';
import 'package:soc_backend/data/model/pages_response.dart';
import 'package:soc_backend/domain/repository/pages_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';

class PagesController extends ResourceController {
  PagesController(
    this.context,
    this.pagesRepository,
  );

  final ManagedContext context;
  final IPagesRepository pagesRepository;

  @Operation.get('batch_id')
  Future<Response> getPagesList(
    @Bind.path('batch_id') final String batchId,
  ) async {
    try {
      final response = await pagesRepository.getPagesList(batchId, context);

      return Response.ok(response);
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    }
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      '200': APIResponse.schema(
        '',
        const PagesResponse(
          currentScenarySoundtrack: '',
          pages: [],
          nextPagesBatch: '',
        ).documentSchema(context),
      )
    };
  }
}
