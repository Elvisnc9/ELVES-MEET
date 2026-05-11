enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

extension AuthStatusX on AuthStatus {
  bool get isAuthenticated   => this == AuthStatus.authenticated;
  bool get isAuthenticating  => this == AuthStatus.authenticating;
  bool get isUnauthenticated => this == AuthStatus.unauthenticated;
}