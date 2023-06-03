import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/services/db.dart';

Middleware databaseProvider() {
  return provider<DatabaseService>((context) => DatabaseService.instance());
}
