import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart';

final _client = DbClient(
  stdout: Event.values,
  datasources: Datasources(db: Platform.environment['DATABASE_URL']),
);

Middleware databaseProvider() {
  return provider<DbClient>((context) => _client);
}
