import 'dart:io';

class EnvironmentConstants {
  static String get jwtSecretKey =>
      Platform.environment['SECRET_KEY'] ?? 'SEO_SECRET_KEY_1!';
  static String? get dbUsername => Platform.environment['DB_USERNAME'];
  static String? get dbName => Platform.environment['DB_NAME'];
  static String? get dbPassword => Platform.environment['DB_PASSWORD'];
  static String? get dbHost => Platform.environment['DB_HOST'];
  static String? get dbPort => Platform.environment['DB_PORT'];
}
