import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:jwt_auth/config.dart';
import 'package:jwt_auth/models/auth_data.dart';

interface class Auth {
  /// Returns (access, refresh) token
  static (String, String) issueJwtPair(
    int userId, {
    Duration accessAge = const Duration(hours: 1),
    Duration refreshAge = const Duration(days: 14),
  }) {
    final accessSet = JwtClaim(
      subject: '$userId',
      maxAge: accessAge,
      issuer: 'my_company_name',
      otherClaims: {'token_type': 'access'},
    );
    final refreshSet = JwtClaim(
      subject: '$userId',
      maxAge: refreshAge,
      issuer: 'my_company_name',
      otherClaims: {'token_type': 'refresh'},
    );

    return (
      issueJwtHS256(accessSet, Config.jwtSecret),
      issueJwtHS256(refreshSet, Config.jwtSecret)
    );
  }

  static AuthData buildAuthData(String jwt) {
    final claim = verifyJwtHS256Signature(jwt, Config.jwtSecret);
    switch (claim['token_type']) {
      case 'access':
        return AuthData.access(claim);
      case 'refresh':
        return AuthData.refresh(claim);
      default:
        return AuthData.none();
    }
  }

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
