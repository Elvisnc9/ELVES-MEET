import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:pluse_flutter/providers/call_provider.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';

// class CallScreen extends ConsumerWidget {
//   const CallScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final call = ref.watch(callStateProvider);

//     return Stack(
//       children: [
//         // Remote video (first remote user, full screen)
//         if (call.remoteUids.isNotEmpty && call.engine != null)
//           AgoraVideoView(
//             controller: VideoViewController.remote(
//               rtcEngine: call.engine!,
//               canvas: VideoCanvas(uid: call.remoteUids.first),
//               connection: RtcConnection(channelId: call.activeMeetingId ?? ''),
//             ),
//           )
//         else
//           const Center(child: Text('Waiting for others to join...')),

//         // Local video (small overlay)
//         if (call.engine != null)
//           Positioned(
//             top: 40,
//             right: 16,
//             width: 100,
//             height: 140,
//             child: AgoraVideoView(
//               controller: VideoViewController(
//                 rtcEngine: call.engine!,
//                 canvas: const VideoCanvas(uid: 0),
//               ),
//             ),
//           ),

//         // Controls
//         Positioned(
//           bottom: 30,
//           left: 0,
//           right: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: Icon(call.isMuted ? Icons.mic_off : Icons.mic, color: Colors.white),
//                 onPressed: () => ref.read(callStateProvider.notifier).toggleMute(),
//               ),
//               IconButton(
//                 icon: Icon(call.isCameraOn ? Icons.videocam : Icons.videocam_off, color: Colors.white),
//                 onPressed: () => ref.read(callStateProvider.notifier).toggleCamera(),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.call_end, color: Colors.red),
//                 onPressed: () async {
//                   await ref.read(callStateProvider.notifier).endCall();
//                   ref.read(navigationProvider).goToHome();
//                 },
//               ),
//               IconButton(
//                 icon: Icon(call.isSpeakerOn ? Icons.volume_up : Icons.volume_off, color: Colors.white),
//                 onPressed: () => ref.read(callStateProvider.notifier).toggleSpeaker(),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}