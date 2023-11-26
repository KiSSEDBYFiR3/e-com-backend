import 'dart:developer' as dev;

import 'package:soc_backend/soc_backend.dart';
import 'package:soc_backend/util/app_error_response.dart';

class ApiDocsController extends ResourceController {
  @Operation.get()
  Future<Response> getDocs() async {
    try {
      final page = File('client.html').openRead();
      final headers = request?.response.headers;
      headers?.contentType = ContentType.html;

      return Response.ok(page, headers: {'Content-Type': 'text/html'});
    } catch (e) {
      dev.log(e.toString());
      return AppResponse.notFound();
    }
  }
}
