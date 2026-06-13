// ignore_for_file: strict_top_level_inference

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/core/enums.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pluse_flutter/main.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

final storage = const FlutterSecureStorage();
final all =  storage.readAll();


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
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '1017604801521-ggo26v7q95e8bm2jh55mtoknefpgf8e1.apps.googleusercontent.com',
    );

    final googleUser = await GoogleSignIn.instance.authenticate();

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) throw Exception('No ID token received from Google');

    final authorization = await googleUser.authorizationClient
        .authorizationForScopes(['email', 'profile']);

    // Capture the AuthSuccess returned by the IDP endpoint
    final authSuccess = await client.googleIdp.login(
      idToken: idToken,
      accessToken: authorization?.accessToken,
    );

    // THIS is the missing step — registers + persists the session
    await client.authSessionManager.updateSignedInUser(authSuccess);

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
    await client.auth.signOutDevice();   // tells server
    await client.authSessionManager.signOutDevice(); // clears local token
    await GoogleSignIn.instance.signOut();
    
  } catch (_) {}

  state = AuthStatus.unauthenticated;
}

}

final isLoggedInProvider = Provider<bool>((ref) {
  return client.authSessionManager.isAuthenticated;
});