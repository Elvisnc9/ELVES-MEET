import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pluse_flutter/main.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

enum AuthState {
  unknown,
  authenticated,
  unauthenticated,
}

final authGuardProvider = FutureProvider<AuthState>((ref) async {
  // IMPORTANT: ensure Serverpod session is restored first
  await client.auth.initialize();

  final isSignedIn =  client.auth.isAuthenticated;

  if (isSignedIn) {
    return AuthState.authenticated;
  }

  return AuthState.unauthenticated;
});