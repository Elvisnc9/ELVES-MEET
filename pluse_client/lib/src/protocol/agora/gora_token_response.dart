/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AgoraTokenResponse implements _i1.SerializableModel {
  AgoraTokenResponse._({
    required this.appId,
    required this.token,
    required this.uid,
    required this.channelName,
  });

  factory AgoraTokenResponse({
    required String appId,
    required String token,
    required int uid,
    required String channelName,
  }) = _AgoraTokenResponseImpl;

  factory AgoraTokenResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AgoraTokenResponse(
      appId: jsonSerialization['appId'] as String,
      token: jsonSerialization['token'] as String,
      uid: jsonSerialization['uid'] as int,
      channelName: jsonSerialization['channelName'] as String,
    );
  }

  String appId;

  String token;

  int uid;

  String channelName;

  /// Returns a shallow copy of this [AgoraTokenResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AgoraTokenResponse copyWith({
    String? appId,
    String? token,
    int? uid,
    String? channelName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AgoraTokenResponse',
      'appId': appId,
      'token': token,
      'uid': uid,
      'channelName': channelName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AgoraTokenResponseImpl extends AgoraTokenResponse {
  _AgoraTokenResponseImpl({
    required String appId,
    required String token,
    required int uid,
    required String channelName,
  }) : super._(
         appId: appId,
         token: token,
         uid: uid,
         channelName: channelName,
       );

  /// Returns a shallow copy of this [AgoraTokenResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AgoraTokenResponse copyWith({
    String? appId,
    String? token,
    int? uid,
    String? channelName,
  }) {
    return AgoraTokenResponse(
      appId: appId ?? this.appId,
      token: token ?? this.token,
      uid: uid ?? this.uid,
      channelName: channelName ?? this.channelName,
    );
  }
}
