import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:jwt_auth/config.dart';
import 'package:jwt_auth/models/auth_data.dart';

typedef JWTPair = ({String access, String refresh});

// TODO: move to some kind of UserService
String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}

abstract class Authenticator {
  factory Authenticator.instance() => _Auth.instance();

  JWTPair issueJwtPair(
    String subject, {
    Duration accessAge = const Duration(hours: 1),
    Duration refreshAge = const Duration(days: 14),
  });
}

abstract class Authorizator {
  factory Authorizator.instance() => _Auth.instance();

  AuthData authorize(String jwt);
}

class _Auth implements Authenticator, Authorizator {
  _Auth(this.config);
  factory _Auth.instance() {
    if (_instance case final instance?) return instance;
    final auth = _Auth(Config.fromEnvironment());
    _instance = auth;
    return auth;
  }

  static _Auth? _instance;

  final Config config;

  @override
  JWTPair issueJwtPair(
    String subject, {
    Duration accessAge = const Duration(hours: 1),
    Duration refreshAge = const Duration(days: 14),
  }) {
    final now = DateTime.now();
    final access = JwtClaim(
      issuedAt: now,
      subject: subject,
      maxAge: accessAge,
      defaultIatExp: false,
      issuer: config.issuer,
    );
    final refresh = JwtClaim(
      issuedAt: now,
      subject: subject,
      maxAge: refreshAge,
      defaultIatExp: false,
      issuer: config.issuer,
    );

    return (
      access: issueJwtHS256(access, config.accessSecret),
      refresh: issueJwtHS256(refresh, config.refreshSecret)
    );
  }

  @override
  AuthData authorize(String header) {
    try {
      final [type, token] = header.split(' ');
      final typeLowercase = type.toLowerCase();

      final secret = switch (typeLowercase) {
        'bearer' => config.accessSecret,
        'refresh' => config.refreshSecret,
        _ => throw Exception('token_type_not_defined'),
      };

      final claim = verifyJwtHS256Signature(token, secret, defaultIatExp: false)
        ..validate(issuer: config.issuer);

      return switch (typeLowercase) {
        'bearer' => AccessAuth(claim),
        'refresh' => RefreshAuth(claim),
        _ => const NoneAuth(),
      } as AuthData;
    } catch (e) {
      return const NoneAuth();
    }
  }
}
