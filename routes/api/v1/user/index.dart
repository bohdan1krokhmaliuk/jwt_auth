import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart';
import 'package:jwt_auth/models/auth_data.dart';

Future<Response> onRequest(RequestContext context) async {
  final details = context.read<UserDetails>();
  if (details.id == null) return Response(statusCode: HttpStatus.forbidden);

  // Check for existing user
  final db = context.read<DbClient>();
  final user =
      await db.user.findUnique(where: UserWhereUniqueInput(id: details.id));

  if (user == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': "User doesn't exist"},
    );
  }

  return Response.json(body: user.toJson()..remove('password'));
}
