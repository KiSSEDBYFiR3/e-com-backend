import 'package:soc_backend/data/model/page.dart';
import 'package:soc_backend/data/model/pages_response.dart';
import 'package:soc_backend/domain/repository/pages_repository.dart';
import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';

class PagesRepository implements IPagesRepository {
  @override
  Future<Response> getPagesList(String batchId, ManagedContext context) async {
    try {
      final query = Query<Page>(context);

      final getPages = query
        ..sortBy((x) => x.id, QuerySortOrder.ascending)
        ..where((x) => x.batchId).equalTo(batchId);

      final pages = await getPages.fetch();

      return Response.ok(
        PagesResponse(
          pages: pages,
          nextPagesBatch: pages.lastOrNull?.nextBatch ?? '',
          currentScenarySoundtrack: pages.firstOrNull?.soundTrack ?? '',
        ).toJson(),
      );
    } on QueryException catch (e) {
      return AppResponse.serverError(e, message: e.message);
    }
  }
}
