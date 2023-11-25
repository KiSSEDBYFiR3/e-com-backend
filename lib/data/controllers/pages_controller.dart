import 'package:soc_backend/domain/repository/pages_repository.dart';
import 'package:soc_backend/soc_backend.dart';

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
    return await pagesRepository.getPagesList(batchId, context);
  }
}
