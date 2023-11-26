import 'package:conduit_common/src/openapi/documentable.dart';
import 'package:conduit_open_api/src/v3/response.dart';
import 'package:soc_backend/data/model/settings.dart';
import 'package:soc_backend/data/model/settings_request.dart';
import 'package:soc_backend/domain/repository/settings_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';

class SettingsController extends ResourceController {
  SettingsController(this.context, this.settingsRepository);

  final ISettingsRepository settingsRepository;

  final ManagedContext context;

  @Operation.get()
  Future<Response> getSettings() async {
    final userId = request!.attachments['userId'] as String;

    try {
      final settings = await settingsRepository.getSettings(userId, context);
      if (settings == null) {
        return AppResponse.notFound();
      }
      return Response.ok(settings);
    } on QueryException catch (e) {
      throw AppResponse.serverError(e, message: e.message);
    }
  }

  @Operation.post()
  Future<Response> updateSettings(
      @Bind.body() SettingsRequest settingsRequest) async {
    final userId = request!.attachments['userId'] as String;
    try {
      final settings = await settingsRepository.updateSettings(
        settingsRequest,
        userId,
        context,
      );
      if (settings == null) {
        return AppResponse.notFound();
      }
      return Response.ok(settings);
    } on QueryException catch (e) {
      throw AppResponse.serverError(e, message: e.message);
    }
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      '200': APIResponse.schema(
        '',
        Settings().documentSchema(context),
      )
    };
  }
}
