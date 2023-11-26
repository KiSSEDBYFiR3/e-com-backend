import 'package:soc_backend/data/model/page.dart';
import 'package:soc_backend/data/model/pages_response.dart';
import 'package:soc_backend/domain/repository/pages_repository.dart';
import 'package:soc_backend/soc_backend.dart';

class PagesRepository implements IPagesRepository {
  @override
  Future<PagesResponse> getPagesList(
      String batchId, ManagedContext context) async {
    try {
      final query = Query<Page>(context);

      final getPages = query
        ..sortBy((x) => x.id, QuerySortOrder.ascending)
        ..where((x) => x.batchId).equalTo(batchId);

      final pages = await getPages.fetch();

      return PagesResponse(
        pages: pages,
        nextPagesBatch: pages.lastOrNull?.nextBatch ?? '',
        currentScenarySoundtrack: pages.firstOrNull?.soundTrack ?? '',
      );
    } on QueryException catch (_) {
      rethrow;
    }
  }
}
