import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/core/enums.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthStatus>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<AuthStatus> {
  AuthNotifier() : super(AuthStatus.unauthenticated);

  /// Google / Facebook sign-in — simulates a network call
  Future<void> signIn() async {
    state = AuthStatus.authenticating;
    await Future.delayed(const Duration(seconds: 2)); // swap with real auth
    state = AuthStatus.authenticated;
  }

  /// "Use without account" — stays unauthenticated, just proceeds
  void continueAsGuest() => state = AuthStatus.unauthenticated;

  void signOut() => state = AuthStatus.unauthenticated;
}