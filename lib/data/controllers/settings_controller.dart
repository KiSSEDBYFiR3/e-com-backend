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
      return await settingsRepository.getSettings(userId, context);
    } on QueryException catch (e) {
      throw AppResponse.serverError(e, message: e.message);
    }
  }

  @Operation.post()
  Future<Response> updateSettings(
      @Bind.body() SettingsRequest settingsRequest) async {
    final userId = request!.attachments['userId'] as String;
    try {
      return await settingsRepository.updateSettings(
        settingsRequest,
        userId,
        context,
      );
    } on QueryException catch (e) {
      throw AppResponse.serverError(e, message: e.message);
    }
  }
}
