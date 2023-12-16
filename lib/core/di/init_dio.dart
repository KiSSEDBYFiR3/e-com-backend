import 'package:dio/dio.dart';
import 'package:ecom_backend/util/external_urls.dart';

Dio initDio() {
  final Dio dio = Dio();

  const timeout = Duration(seconds: 30);

  dio.options
    ..baseUrl = Url.defaultUrl
    ..sendTimeout = timeout
    ..receiveTimeout = timeout
    ..connectTimeout = timeout;

  return dio;
}
