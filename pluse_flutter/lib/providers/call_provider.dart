import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pluse_flutter/main.dart';

final callStateProvider =
    StateNotifierProvider<CallStateNotifier, CallState>((ref) {
  return CallStateNotifier();
});

class CallState {
  final bool isMuted;
  final bool isCameraOn;
  final bool isSpeakerOn;
  final String? activeMeetingId;
  final RtcEngine? engine;
  final int? localUid;
  final Set<int> remoteUids;
  final bool isJoining;

  CallState({
    this.isMuted = false,
    this.isCameraOn = true,
    this.isSpeakerOn = true,
    this.activeMeetingId,
    this.engine,
    this.localUid,
    this.remoteUids = const {},
    this.isJoining = false,
  });

  CallState copyWith({
    bool? isMuted,
    bool? isCameraOn,
    bool? isSpeakerOn,
    String? activeMeetingId,
    RtcEngine? engine,
    int? localUid,
    Set<int>? remoteUids,
    bool? isJoining,
  }) {
    return CallState(
      isMuted: isMuted ?? this.isMuted,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      activeMeetingId: activeMeetingId ?? this.activeMeetingId,
      engine: engine ?? this.engine,
      localUid: localUid ?? this.localUid,
      remoteUids: remoteUids ?? this.remoteUids,
      isJoining: isJoining ?? this.isJoining,
    );
  }
}

class CallStateNotifier extends StateNotifier<CallState> {
  CallStateNotifier() : super(CallState());

  Future<bool> requestPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    return statuses.values.every((s) => s.isGranted);
  }

  Future<void> joinChannel(String channelName) async {
    state = state.copyWith(isJoining: true);

    try {
      // 1. Request permissions
      final granted = await requestPermissions();
      if (!granted) {
        state = state.copyWith(isJoining: false);
        throw Exception('Camera/microphone permissions denied');
      }

      // 2. Get token from your Serverpod server
      final tokenResponse = await client.agora.getToken(channelName);

      // 3. Create + initialize Agora engine
      final engine = createAgoraRtcEngine();
      await engine.initialize(RtcEngineContext(appId: tokenResponse.appId));

      // 4. Register event handlers
      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            state = state.copyWith(
              localUid: connection.localUid,
              isJoining: false,
            );
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            state = state.copyWith(
              remoteUids: {...state.remoteUids, remoteUid},
            );
          },
          onUserOffline: (connection, remoteUid, reason) {
            final updated = {...state.remoteUids}..remove(remoteUid);
            state = state.copyWith(remoteUids: updated);
          },
          onError: (err, msg) {
            state = state.copyWith(isJoining: false);
          },
        ),
      );

      // 5. Enable video
      await engine.enableVideo();
      await engine.startPreview();

      // 6. Join the channel
      await engine.joinChannel(
        token: tokenResponse.token,
        channelId: tokenResponse.channelName,
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
    } catch (e) {
      state = state.copyWith(isJoining: false);
      rethrow;
    }
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