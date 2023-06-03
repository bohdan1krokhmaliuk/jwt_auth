import 'package:jaguar_jwt/jaguar_jwt.dart';

class AuthData {
  AuthData.access(this._claim)
      : canAccess = true,
        canRefresh = false;

  AuthData.refresh(this._claim)
      : canAccess = false,
        canRefresh = true;

  AuthData.none()
      : _claim = null,
        canAccess = false,
        canRefresh = false;

  final bool canRefresh;
  final bool canAccess;
  final JwtClaim? _claim;

  JwtClaim get claim {
    assert(
      canRefresh || canAccess,
      'JWT claim only accessable if refresh or access possible',
    );
    return _claim!;
  }
}
