import 'dart:io';

/// Collection of static config secrets
class Config {
  const Config({
    required this.issuer,
    required this.accessSecret,
    required this.refreshSecret,
  });

  factory Config.fromEnvironment() {
    final env = Platform.environment;
    return Config(
      issuer: env['JWT_ISSUER']!,
      accessSecret: env['JWT_ACCESS_SECRET']!,
      refreshSecret: env['JWT_REFRESH_SECRET']!,
    );
  }

  final String issuer;
  final String accessSecret;
  final String refreshSecret;
}
