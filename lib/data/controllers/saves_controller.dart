import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/response.dart';
import 'package:soc_backend/data/model/saves.dart';
import 'package:soc_backend/data/model/saves_request.dart';
import 'package:soc_backend/data/model/saves_response.dart';
import 'package:soc_backend/domain/repository/saves_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';

class SavesController extends ResourceController {
  SavesController(this.context, this.savesRepository);

  final ManagedContext context;
  final ISavesRepository savesRepository;

  @Operation.get()
  Future<Response> getSaves() async {
    try {
      final userId = request!.attachments['userId'] as String;
      final saves = await savesRepository.getSaves(userId, context);

      return Response.ok(SavesResponse(saves));
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    }
  }

  @Operation.post()
  Future<Response> save(@Bind.body() SavesRequest savesRequest) async {
    try {
      final userId = request!.attachments['userId'] as String;
      final save = await savesRepository.save(savesRequest, userId, context);
      if (save == null) {
        return AppResponse.badRequest();
      }
      return Response.ok(save);
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    }
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    if (operation.method == "GET") {
      return {
        '200': APIResponse.schema(
          '',
          const SavesResponse([]).documentSchema(context),
        )
      };
    } else {
      return {
        '200': APIResponse.schema(
          '',
          Save().documentSchema(context),
        )
      };
    }
  }
}
