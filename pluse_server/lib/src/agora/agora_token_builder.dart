import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

// Agora AccessToken2 implementation in Dart
// Based on: github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey

class AgoraTokenBuilder {
  static const int rolePublisher = 1;
  static const int roleSubscriber = 2;

  static String buildTokenWithUid({
    required String appId,
    required String appCertificate,
    required String channelName,
    required int uid,
    required int role,
    int tokenExpireSeconds = 3600,
    int privilegeExpireSeconds = 3600,
  }) {
    final issueTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expireTs = issueTs + tokenExpireSeconds;
    final salt = Random.secure().nextInt(0xFFFFFFFF);

    // Pack the message
    final msgBuf = BytesBuilder();
    msgBuf.add(_packUint32(salt));
    msgBuf.add(_packUint32(issueTs));
    msgBuf.add(_packUint32(expireTs));
    msgBuf.add(_packString(channelName));
    msgBuf.add(_packUint32(uid));

    // Privileges
    final privileges = <int, int>{};
    if (role == rolePublisher) {
      privileges[1] = expireTs; // joinChannel
      privileges[2] = expireTs; // publishAudioStream
      privileges[3] = expireTs; // publishVideoStream
      privileges[7] = expireTs; // publishDataStream
    } else {
      privileges[1] = expireTs; // joinChannel
    }

    final privBuf = BytesBuilder();
    privBuf.add(_packUint16(privileges.length));
    for (final entry in privileges.entries) {
      privBuf.add(_packUint16(entry.key));
      privBuf.add(_packUint32(entry.value));
    }

    msgBuf.add(privBuf.takeBytes());

    final msgBytes = msgBuf.takeBytes();
    final sigBuf = BytesBuilder();
    sigBuf.add(utf8.encode(appId));
    sigBuf.add(utf8.encode(channelName));
    sigBuf.add(_packUint32(uid));
    sigBuf.add(msgBytes);

    final hmac = Hmac(sha256, utf8.encode(appCertificate));
    final sig = hmac.convert(sigBuf.takeBytes()).bytes;

    // Build token bytes
    final tokenBuf = BytesBuilder();
    tokenBuf.add(_packBytes(Uint8List.fromList(sig)));
    tokenBuf.add(msgBytes);

    final compressed = _compress(tokenBuf.takeBytes());
    final b64 = base64Url.encode(compressed);
    return '007$b64';
  }

  static Uint8List _packUint16(int v) {
    final b = Uint8List(2);
    ByteData.view(b.buffer).setUint16(0, v, Endian.little);
    return b;
  }

  static Uint8List _packUint32(int v) {
    final b = Uint8List(4);
    ByteData.view(b.buffer).setUint32(0, v, Endian.little);
    return b;
  }

  static Uint8List _packString(String s) {
    final encoded = utf8.encode(s);
    final buf = BytesBuilder();
    buf.add(_packUint16(encoded.length));
    buf.add(encoded);
    return buf.takeBytes();
  }

  static Uint8List _packBytes(Uint8List bytes) {
    final buf = BytesBuilder();
    buf.add(_packUint16(bytes.length));
    buf.add(bytes);
    return buf.takeBytes();
  }

  static Uint8List _compress(Uint8List data) {
    // Agora uses zlib compression
    return ZLibCodec().encode(data) as Uint8List;
  }
}