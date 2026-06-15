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
  final call = ref.watch(callStateProvider);

  if (call.isJoining) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Joining call...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        // Remote video — full screen
        if (call.remoteUids.isNotEmpty && call.engine != null)
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: call.engine!,
              canvas: VideoCanvas(uid: call.remoteUids.first),
              connection: RtcConnection(channelId: call.activeMeetingId ?? ''),
            ),
          )
        else
          const Center(
            child: Text(
              'Waiting for others to join...',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ),

        // Local video — small overlay top right
        if (call.engine != null)
          Positioned(
            top: 40,
            right: 16,
            width: 110,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: call.engine!,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            ),
          ),

        // Controls bar
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CallButton(
                icon: call.isMuted ? Icons.mic_off : Icons.mic,
                color: call.isMuted ? Colors.red : Colors.white24,
                onTap: () => ref.read(callStateProvider.notifier).toggleMute(),
              ),
              _CallButton(
                icon: Icons.call_end,
                color: Colors.red,
                size: 32,
                onTap: () async {
                  await ref.read(callStateProvider.notifier).endCall();
                  ref.read(navigationProvider).goToHome();
                },
              ),
              _CallButton(
                icon: call.isCameraOn ? Icons.videocam : Icons.videocam_off,
                color: call.isCameraOn ? Colors.white24 : Colors.red,
                onTap: () =>
                    ref.read(callStateProvider.notifier).toggleCamera(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}


class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const _CallButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}