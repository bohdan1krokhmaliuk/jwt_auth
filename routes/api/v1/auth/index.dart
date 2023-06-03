import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/models/auth_data.dart';

Response onRequest(RequestContext context) {
  final data = context.read<AuthData>();
  return Response.json(
    body: {
      'can_access': data.canAccess,
      'can_refresh': data.canRefresh,
    },
  );
}
