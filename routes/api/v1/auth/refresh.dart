import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/models/auth_data.dart';
import 'package:jwt_auth/services/auth.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      final auth = context.read<AuthData>();
      if (auth is! RefreshAuth) {
        return Response(statusCode: HttpStatus.forbidden);
      }

      if (auth.claim.subject case final subject?) {
        final jwtPair = context.read<Authenticator>().issueJwtPair(subject);
        return Response.json(
          body: {'access': jwtPair.access, 'refresh': jwtPair.refresh},
        );
      }
      return Response.json(statusCode: HttpStatus.forbidden);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
