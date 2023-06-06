import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/middlewares/auth.dart';
import 'package:jwt_auth/middlewares/database_provider.dart';

Handler middleware(Handler handler) {
  return handler
      .use(databaseProvider())
      .use(userDetailsProvider())
      .use(authorize());
}
