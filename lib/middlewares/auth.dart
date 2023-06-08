import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/models/auth_data.dart';
import 'package:jwt_auth/services/auth.dart';

Middleware userDetailsProvider() {
  return provider<UserDetails>((context) {
    final auth = context.read<AuthData>();
    try {
      return UserDetails(int.parse((auth as AccessAuth).claim.subject!));
    } catch (e) {
      return const UserDetails.empty();
    }
  });
}

Middleware authorize() {
  return provider<AuthData>((context) {
    if (context.request.headers['Authorization'] case final token?) {
      return Authorizator.instance().authorize(token);
    }
    return const NoneAuth();
  });
}

Middleware authenticatorProvider() {
  return provider<Authenticator>((context) => Authenticator.instance());
}
