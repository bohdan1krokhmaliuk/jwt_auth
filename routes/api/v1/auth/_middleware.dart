import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/middlewares/auth.dart';

Handler middleware(Handler handler) {
  return handler.use(authenticatorProvider());
}
