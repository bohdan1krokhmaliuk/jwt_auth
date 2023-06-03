import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_auth/models/auth_data.dart';
import 'package:jwt_auth/models/user.dart';
import 'package:jwt_auth/services/db.dart';

Future<Response> onRequest(RequestContext context) async {
  // Serialization
  final authData = context.read<AuthData>();
  final userId = int.tryParse(authData.claim.subject ?? '');
  if (!authData.canAccess || userId == null) {
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

  return Response.json(
    body: {
      'id': user.id,
      'email': user.email,
      'created_at': user.createdAt.toIso8601String(),
    },
  );
}
