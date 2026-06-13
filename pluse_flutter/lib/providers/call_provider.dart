import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/main.dart';

final callStateProvider = StateNotifierProvider<CallStateNotifier, CallState>((ref) {
  return CallStateNotifier();
});

class CallState {
  final bool isMuted;
  final bool isCameraOn;
  final bool isSpeakerOn;
  final bool isScreenSharing;
  final Duration callDuration;
  final String? activeMeetingId;
  final RtcEngine? engine;
  final int? localUid;
  final Set<int> remoteUids;

  CallState({
    this.isMuted = false,
    this.isCameraOn = true,
    this.isSpeakerOn = true,
    this.isScreenSharing = false,
    this.callDuration = Duration.zero,
    this.activeMeetingId,
    this.engine,
    this.localUid,
    this.remoteUids = const {},
  });

  CallState copyWith({
    bool? isMuted,
    bool? isCameraOn,
    bool? isSpeakerOn,
    bool? isScreenSharing,
    Duration? callDuration,
    String? activeMeetingId,
    RtcEngine? engine,
    int? localUid,
    Set<int>? remoteUids,
  }) {
    return CallState(
      isMuted: isMuted ?? this.isMuted,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isScreenSharing: isScreenSharing ?? this.isScreenSharing,
      callDuration: callDuration ?? this.callDuration,
      activeMeetingId: activeMeetingId ?? this.activeMeetingId,
      engine: engine ?? this.engine,
      localUid: localUid ?? this.localUid,
      remoteUids: remoteUids ?? this.remoteUids,
    );
  }
}

class CallStateNotifier extends StateNotifier<CallState> {
  CallStateNotifier() : super(CallState());

  Future<void> joinChannel(String channelName) async {
    // 1. Get token from server
    final tokenResponse = await client.agora.getToken(channelName);

    // 2. Create + initialize engine
    final engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: tokenResponse.appId));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          state = state.copyWith(localUid: connection.localUid);
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          state = state.copyWith(remoteUids: {...state.remoteUids, remoteUid});
        },
        onUserOffline: (connection, remoteUid, reason) {
          final updated = {...state.remoteUids}..remove(remoteUid);
          state = state.copyWith(remoteUids: updated);
        },
      ),
    );

    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: tokenResponse.token,
      channelId: channelName,
      uid: tokenResponse.uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    state = state.copyWith(
      engine: engine,
      activeMeetingId: channelName,
      localUid: tokenResponse.uid,
    );
  }

  Future<void> toggleMute() async {
    final newMuted = !state.isMuted;
    await state.engine?.muteLocalAudioStream(newMuted);
    state = state.copyWith(isMuted: newMuted);
  }

  Future<void> toggleCamera() async {
    final newCameraOn = !state.isCameraOn;
    await state.engine?.muteLocalVideoStream(!newCameraOn);
    state = state.copyWith(isCameraOn: newCameraOn);
  }

  Future<void> toggleSpeaker() async {
    final newSpeakerOn = !state.isSpeakerOn;
    await state.engine?.setEnableSpeakerphone(newSpeakerOn);
    state = state.copyWith(isSpeakerOn: newSpeakerOn);
  }

  Future<void> endCall() async {
    await state.engine?.leaveChannel();
    await state.engine?.release();
    state = CallState();
  }
}