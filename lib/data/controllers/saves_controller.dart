import 'package:soc_backend/data/model/saves_request.dart';
import 'package:soc_backend/domain/repository/saves_repository.dart';
import 'package:soc_backend/soc_backend.dart';

class SavesController extends ResourceController {
  SavesController(this.context, this.savesRepository);

  final ManagedContext context;
  final ISavesRepository savesRepository;

  @Operation.get()
  Future<Response> getSaves() async {
    final userId = request!.attachments['userId'] as String;
    return await savesRepository.getSaves(userId, context);
  }

  @Operation.post()
  Future<Response> save(@Bind.body() SavesRequest savesRequest) async {
    final userId = request!.attachments['userId'] as String;
    return await savesRepository.save(savesRequest, userId, context);
  }
}
