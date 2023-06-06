import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/models/auth_data.dart';

Response onRequest(RequestContext context) {
  final data = context.read<AuthData>();

  return Response.json(
    body: {
      'can_access': data is AccessAuth,
      'can_refresh': data is RefreshAuth,
      'user_id':
          data is ClaimDetails ? (data as ClaimDetails).claim.subject : null,
    },
  );
}
