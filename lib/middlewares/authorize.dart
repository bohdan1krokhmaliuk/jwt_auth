import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/models/auth_data.dart';
import 'package:jwt_auth/services/auth.dart';

Middleware authorize() {
  return provider<AuthData>((context) {
    try {
      final token = context.request.headers['Authorization']!.trim();
      return Auth.buildAuthData(token);
    } catch (e) {
      return AuthData.none();
    }
  });
}
