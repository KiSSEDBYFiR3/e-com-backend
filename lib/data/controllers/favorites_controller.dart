import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:ecom_backend/data/model/favorite_model.dart';
import 'package:ecom_backend/domain/repository/favorites_repository.dart';
import 'package:ecom_backend/util/app_error_response.dart';

class FavoritesController extends ResourceController {
  FavoritesController({
    required this.context,
    required this.repository,
  });

  final IFavoritesRepository repository;
  final ManagedContext context;

  @Operation.post('id')
  Future<Response> addToFavorites() async {
    final userId = request!.attachments['userId'] as String;
    final id = request!.raw.requestedUri.queryParameters['id'];
    if (id == null) {
      return AppResponse.badRequest();
    }

    try {
      final response = await repository.addToFavorites(
        id: int.parse(id),
        userId: userId,
        context: context,
      );
      return Response.ok(response);
    } catch (e) {
      logger.severe(e.toString());

      return AppResponse.serverError(e.toString());
    }
  }

  @Operation.get()
  Future<Response> getFavorites() async {
    final userId = request!.attachments['userId'] as String;

    try {
      final favoritesResponse =
          await repository.getFavorites(userId: userId, context: context);
      return Response.ok(
        favoritesResponse,
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      logger.severe(e.toString());

      return AppResponse.serverError(e.toString());
    }
  }

  @Operation.delete('id')
  Future<Response> deleteFromFavorites() async {
    final userId = request!.attachments['userId'] as String;
    final id = request!.raw.requestedUri.queryParameters['id'];
    if (id == null) {
      return AppResponse.badRequest();
    }
    try {
      final favoritesResponse = await repository.deleteFromFavorites(
        userId: userId,
        context: context,
        id: int.parse(id),
      );
      return Response.ok(favoritesResponse);
    } catch (e) {
      logger.severe(e.toString());

      return AppResponse.serverError(e.toString());
    }
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      '200': APIResponse.schema(
        '',
        APISchemaObject.array(
          ofSchema: FavoriteProduct().documentSchema(context),
        ),
      )
    };
  }
}
