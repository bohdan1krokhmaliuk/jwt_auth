import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/models/auth_data.dart';
import 'package:jwt_auth/models/user.dart';
import 'package:jwt_auth/services/auth.dart';
import 'package:jwt_auth/services/db.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      // Serialization
      final authData = context.read<AuthData>();
      final userId = int.tryParse(authData.claim.subject ?? '');
      if (userId == null) {
        return Response(statusCode: HttpStatus.unauthorized);
      }

      // Check for existing user
      final db = context.read<DatabaseService>();
      final user = await db.get<User>((user) => user.id == userId);
      if (user == null) {
        return Response.json(
          statusCode: HttpStatus.notFound,
          body: {'error': "User doesn't exist"},
        );
      }

      final (access, refresh) = Auth.issueJwtPair(user.id);
      return Response.json(body: {'access': access, 'refresh': refresh});
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
