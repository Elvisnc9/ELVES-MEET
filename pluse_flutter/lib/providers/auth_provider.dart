import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/core/enums.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthStatus>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<AuthStatus> {
  AuthNotifier() : super(AuthStatus.unauthenticated);

  /// Simulates a 4-second network call — swap body with real auth later
  Future<void> signIn() async {
    state = AuthStatus.authenticating;
    await Future.delayed(const Duration(seconds: 2));
    state = AuthStatus.authenticated;
  }

  void continueAsGuest() => state = AuthStatus.unauthenticated;

  void signOut() => state = AuthStatus.unauthenticated;
}