import 'package:soc_backend/data/model/pages_response.dart';
import 'package:soc_backend/soc_backend.dart';

abstract interface class IPagesRepository {
  Future<PagesResponse> getPagesList(
    String batchId,
    ManagedContext context,
  );
}
