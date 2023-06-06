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
      final passwordHash = hashPassword(password);
      final db = context.read<DatabaseService>();
      final user = await db.get<User>((user) => user.email == email);
      if (user == null || user.passwordHash != passwordHash) {
        return Response.json(
          statusCode: HttpStatus.forbidden,
          body: {'error': 'Invalid email or password'},
        );
      }

      final jwtPair = context.read<Authenticator>().issueJwtPair('${user.id}');
      return Response.json(
        body: {'access': jwtPair.access, 'refresh': jwtPair.refresh},
      );
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
