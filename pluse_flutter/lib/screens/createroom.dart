import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';
import 'package:pluse_flutter/providers/call_provider.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';

final createRoomPanelProvider = StateProvider<bool>((ref) => false);
final createRoomLoadingProvider = StateProvider<bool>((ref) => false);

/// Holds the channel name generated when user taps "Create Room"
final createdChannelProvider = StateProvider<String?>((ref) => null);

/// Generates a Google Meet–style random channel code, e.g. "abc-mnop-xyz"
String generateChannelName() {
  const chars = 'abcdefghijklmnopqrstuvwxyz';
  final rand = Random.secure();
  String seg(int n) =>
      List.generate(n, (_) => chars[rand.nextInt(chars.length)]).join();
  return '${seg(3)}-${seg(4)}-${seg(3)}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Overlay widget — drop this inside the root Stack in AppShell
// ─────────────────────────────────────────────────────────────────────────────

class CreateRoomPanel extends ConsumerWidget {
  const CreateRoomPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(createRoomPanelProvider);
    final isLoading = ref.watch(createRoomLoadingProvider);
    final channelName = ref.watch(createdChannelProvider);

    return IgnorePointer(
      ignoring: !open,
      child: AnimatedOpacity(
        opacity: open ? 1 : 0,
        duration: const Duration(milliseconds: 150),
        child: Stack(
          children: [
            // ── backdrop ──────────────────────────────────────────────────
            GestureDetector(
              onTap: () =>
                  ref.read(createRoomPanelProvider.notifier).state = false,
              child: Container(color: Colors.black.withOpacity(0.45)),
            ),

            // ── bottom sheet ──────────────────────────────────────────────
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                offset: open ? Offset.zero : const Offset(0, 1),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF111111),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: isLoading
                            ? _LoadingView(key: const ValueKey('loader'))
                            : _ContentView(
                                key: const ValueKey('content'),
                                channelName: channelName,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 4, color: Colors.white),
          SizedBox(height: 2.h),
          Text(
            'Creating room…',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white70,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ContentView extends ConsumerWidget {
  final String? channelName;
  const _ContentView({super.key, required this.channelName});

  void _copy(BuildContext context) {
    if (channelName == null) return;
    Clipboard.setData(ClipboardData(text: channelName!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Meeting code copied!',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w500),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF2D2D2D),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── drag handle ───────────────────────────────────────────────────
        Center(
          child: Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── title ─────────────────────────────────────────────────────────
        Text(
          'Share this code to invite others',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Anyone with this code can join your meeting.',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white54,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 3.h),

        // ── copyable code box ─────────────────────────────────────────────
        GestureDetector(
          onTap: () => _copy(context),
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    channelName ?? '—',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.copy_rounded, color: Colors.white60, size: 20),
              ],
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // ── action buttons ────────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.copy_rounded,
                label: 'Copy Code',
                onTap: () => _copy(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.video_call_rounded,
                label: 'Join Now',
                primary: true,
                onTap: () async {
                  if (channelName == null) return;

                  // close the panel first
                  ref.read(createRoomPanelProvider.notifier).state = false;

                  try {
                    await ref
                        .read(callStateProvider.notifier)
                        .joinChannel(channelName!);
                    ref.read(navigationProvider).callScreen(channelName!);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to join: $e',
                            style:
                                GoogleFonts.spaceGrotesk(color: Colors.white),
                          ),
                          backgroundColor: Colors.red.shade700,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: primary
              ? const Color(0xFF1A73E8)
              : Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: primary
              ? null
              : Border.all(color: Colors.white.withOpacity(0.18), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy ShareButton kept for any other usages
// ─────────────────────────────────────────────────────────────────────────────

class ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ShareButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Colors.white.withOpacity(0.20), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20.sp),
              SizedBox(width: 3.w),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}