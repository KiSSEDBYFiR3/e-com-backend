import 'package:soc_backend/soc_backend.dart';

abstract interface class IPagesRepository {
  Future<Response> getPagesList(
    String batchId,
    ManagedContext context,
  );
}
