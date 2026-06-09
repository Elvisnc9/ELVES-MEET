import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/core/enums.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pluse_flutter/main.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthStatus>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<AuthStatus> {
  AuthNotifier() : super(AuthStatus.unauthenticated);

  /// Simulates a 4-second network call — swap body with real auth later
Future<void> signInWithGoogle() async {
  state = AuthStatus.authenticating;
  try {
    final signIn = GoogleSignIn.instance;

    await signIn.initialize(
      serverClientId: '1017604801521-ggo26v7q95e8bm2jh55mtoknefpgf8e1.apps.googleusercontent.com', // from Google Cloud Console
    );

    final googleUser = await signIn.authenticate();

    // idToken comes from authentication
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) throw Exception('No ID token received');

    // accessToken requires a separate authorization request in v7
    final authorization = await googleUser.authorizationClient
        .authorizationForScopes(['email', 'profile']);

    await client.googleIdp.login(
      idToken: idToken,
      accessToken: authorization?.accessToken,
    );

    state = AuthStatus.authenticated;
  } catch (e) {
    state = AuthStatus.unauthenticated;
    rethrow;
  }
}

  void continueAsGuest() => state = AuthStatus.unauthenticated;

 Future<void> signOut() async {
  await GoogleSignIn.instance.signOut();
  state = AuthStatus.unauthenticated;
}
}