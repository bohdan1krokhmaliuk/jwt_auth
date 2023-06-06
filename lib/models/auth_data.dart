import 'package:jaguar_jwt/jaguar_jwt.dart';

abstract class ClaimDetails {
  const ClaimDetails(this.claim);
  final JwtClaim claim;
}

sealed class AuthData {
  const AuthData();
}

class AccessAuth extends ClaimDetails implements AuthData {
  const AccessAuth(super.subject);
}

class RefreshAuth extends ClaimDetails implements AuthData {
  const RefreshAuth(super.subject);
}

class NoneAuth implements AuthData {
  const NoneAuth();
}
