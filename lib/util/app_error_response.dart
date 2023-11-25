import 'package:conduit_core/conduit_core.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppResponse extends Response {
  AppResponse.badRequest({String? title, String? details})
      : super.badRequest(
            body:
                ErrorResponse(title: title ?? "Bad request", details: details));

  AppResponse.unauthorized({String? title, String? details})
      : super.unauthorized(
            body: ErrorResponse(
                title: title ?? "Unauthorized", details: details));

  AppResponse.forbidden({String? title, String? details})
      : super.forbidden(
            body: ErrorResponse(title: title ?? "Forbidden", details: details));

  AppResponse.notFound({String? title, String? details})
      : super.notFound(
            body: ErrorResponse(title: title ?? "Not found", details: details));

  AppResponse.serverError(dynamic error, {String? message})
      : super.serverError(body: _getResponseModel(error, message));

  static ErrorResponse _getResponseModel(error, String? message) {
    if (error is QueryException || error is JwtException) {
      return ErrorResponse(
          details: error.toString(),
          title: message ?? error.message.toString());
    }

    return ErrorResponse(
        details: error.toString(), title: message ?? 'Unknown error');
  }
}

class ErrorResponse {
  ErrorResponse({this.title, this.details});

  final String? title;
  final String? details;

  Map<String, dynamic> toJson() =>
      {'title': title ?? '', 'details': details ?? ''};
}
