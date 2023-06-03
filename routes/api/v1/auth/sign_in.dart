import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/models/user.dart';
import 'package:jwt_auth/services/auth.dart';
import 'package:jwt_auth/services/db.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      // Serialization
      late String email;
      late String password;
      try {
        final json = await context.request.json() as Map<String, dynamic>;
        password = json['password'] as String;
        email = json['email'] as String;
      } catch (e) {
        return Response(statusCode: HttpStatus.unprocessableEntity);
      }

      // Server validation
      final emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{1,4}$');
      if (!emailRegEx.hasMatch(email) || password.length < 8) {
        return Response(statusCode: HttpStatus.unprocessableEntity);
      }

      // Check for existing user
      final authHash = Auth.hashPassword(password);
      final db = context.read<DatabaseService>();
      final user = await db.get<User>((user) => user.email == email);
      if (user == null || user.authHash != authHash) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'error': 'Invalid email or password'},
        );
      }

      final (access, refresh) = Auth.issueJwtPair(user.id);
      return Response.json(body: {'access': access, 'refresh': refresh});
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
