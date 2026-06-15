import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import '../generated/protocol.dart';
import 'agora_token_builder.dart';

class AgoraEndpoint extends Endpoint {
  Future<AgoraTokenResponse> getToken(
    Session session,
    String channelName,
  ) async {
    // Must be authenticated
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('User must be authenticated to join a call');
    }

    final appId = session.passwords['agoraAppId']!;
    final appCertificate = session.passwords['agoraAppCertificate']!;

    // Derive a stable numeric UID from the user's UUID
    // We use the last 8 chars of their authUserId parsed as hex → int
    final userIdStr = authInfo.authUserId.toString().replaceAll('-', '');
    final uid = int.parse(userIdStr.substring(userIdStr.length - 8), radix: 16)
        .abs() % 100000000;

    final token = AgoraTokenBuilder.buildTokenWithUid(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      uid: uid,
      role: AgoraTokenBuilder.rolePublisher,
      tokenExpireSeconds: 3600,
      privilegeExpireSeconds: 3600,
    );

    return AgoraTokenResponse(
      appId: appId,
      token: token,
      uid: uid,
      channelName: channelName,
    );
  }
}