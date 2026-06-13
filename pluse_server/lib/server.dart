import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

void run(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      GoogleIdpConfig(
        clientSecret: GoogleClientSecret.fromJsonString(
          pod.getPassword('googleClientSecret')!,
        ),
        clockSkewTolerance: Duration(seconds: 120),
      ),
    ],
    userProfileConfig: UserProfileConfig(
      onAfterUserProfileCreated:
          (session, userProfile, {required transaction}) async {
            await AuthServices.instance.userProfiles.setDefaultUserImage(
              session,
              userProfile.authUserId,
              transaction: transaction,
            );
          },
    ),
  );

  await pod.start();
}