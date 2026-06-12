import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/core/enums.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pluse_flutter/main.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthStatus>((ref) => AuthNotifier());

final navigationProvider = Provider<NavigationController>((ref) {
  return NavigationController(ref);
});

class AuthNotifier extends StateNotifier<AuthStatus> {
  AuthNotifier() : super(AuthStatus.unauthenticated);

  Future<void> signInWithGoogle() async {
    state = AuthStatus.authenticating;
    try {
      // Initialize with the WEB client ID as serverClientId.
      // This must match the client_id in your passwords.yaml googleClientSecret.
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '1017604801521-ggo26v7q95e8bm2jh55mtoknefpgf8e1.apps.googleusercontent.com',
      );

      final googleUser = await GoogleSignIn.instance.authenticate();

      final idToken = googleUser.authentication.idToken;
      if (idToken == null) throw Exception('No ID token received from Google');

      // Request authorization to get access token
      final authorization = await googleUser.authorizationClient
          .authorizationForScopes(['email', 'profile']);

      // Send to your Serverpod server
      await client.googleIdp.login(
        idToken: idToken,
        accessToken: authorization?.accessToken,
      );

      state = AuthStatus.authenticated;
    } on Exception {
      state = AuthStatus.unauthenticated;
      rethrow;
    }
  }

  void continueAsGuest() {
    state = AuthStatus.unauthenticated;
  }

  Future<void> signOut() async {
  try {
    await client.auth.signOutDevice();
    await client.authSessionManager.signOutDevice();
    await GoogleSignIn.instance.signOut();
  } catch (_) {}

  state = AuthStatus.unauthenticated;
}


}

final isLoggedInProvider = Provider<bool>((ref) {
  return client.authSessionManager.isAuthenticated;
});