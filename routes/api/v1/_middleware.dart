import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/middlewares/authorize.dart';
import 'package:jwt_auth/middlewares/database_provider.dart';

Handler middleware(Handler handler) {
  return handler.use(databaseProvider()).use(authorize());
}
