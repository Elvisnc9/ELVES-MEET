import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pluse_flutter/core/enums.dart';
import 'package:pluse_flutter/core/theme/app_colors.dart';
import 'package:pluse_flutter/providers/auth_provider.dart'
    hide navigationProvider;
import 'package:pluse_flutter/providers/call_provider.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';
import 'package:pluse_flutter/screens/createroom.dart';
import 'package:pluse_flutter/widget/home_widget/FabButton.dart';
import 'package:pluse_flutter/widget/home_widget/drawer.dart';
import 'package:pluse_flutter/widget/home_widget/topbar.dart';
import 'package:pluse_flutter/widget/loader.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

final drawerOpenProvider = StateProvider<bool>((ref) => false);

// ─── Recent Call model ────────────────────────────────────────────────────────

class RecentCall {
  final String channelName;
  final DateTime date;
  final List<String> participantInitials;

  const RecentCall({
    required this.channelName,
    required this.date,
    required this.participantInitials,
  });

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return 'Today, $hour:$minute $period';
    } else if (diff.inDays == 1) {
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return 'Yesterday, $hour:$minute $period';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// ─── Dummy data ───────────────────────────────────────────────────────────────

final _dummyCalls = [
  RecentCall(
    channelName: 'abc-mnop-xyz',
    date: DateTime.now().subtract(const Duration(hours: 2)),
    participantInitials: ['AO', 'MK', 'EJ'],
  ),
  RecentCall(
    channelName: 'def-qrst-uvw',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    participantInitials: ['TN', 'BL'],
  ),
  RecentCall(
    channelName: 'ghi-vwxy-jkl',
    date: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    participantInitials: ['AO', 'EJ', 'RD', 'KS'],
  ),
  RecentCall(
    channelName: 'mno-abcd-pqr',
    date: DateTime.now().subtract(const Duration(days: 3)),
    participantInitials: ['MK'],
  ),
  RecentCall(
    channelName: 'stu-efgh-vwx',
    date: DateTime.now().subtract(const Duration(days: 5)),
    participantInitials: ['BL', 'TN', 'AO'],
  ),
];

// ─── Avatar palette ───────────────────────────────────────────────────────────

const _avatarBgs = [
  Color(0xFFB5D4F4),
  Color(0xFFC0DD97),
  Color(0xFFF4C0D1),
  Color(0xFFCECBF6),
  Color(0xFFFAC775),
  Color(0xFF9FE1CB),
];
const _avatarFgs = [
  Color(0xFF0C447C),
  Color(0xFF3B6D11),
  Color(0xFF72243E),
  Color(0xFF3C3489),
  Color(0xFF633806),
  Color(0xFF085041),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _codeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await [Permission.camera, Permission.microphone].request();
    });
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _onCreateRoom() async {
    final channelName = generateChannelName();
    ref.read(createdChannelProvider.notifier).state = channelName;
    ref.read(createRoomLoadingProvider.notifier).state = true;
    ref.read(createRoomPanelProvider.notifier).state = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      ref.read(createRoomLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (auth.isAuthenticating) return const LoadingScreen();

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 1.5.h),
            TopBar(
              ctrl: _codeCtrl,
              onMenuTap: () =>
                  ref.read(drawerOpenProvider.notifier).state = true,
              onCodeTap: () {
                FocusScope.of(context).unfocus();
                ref.read(navigationProvider).openCodeSearch();
              },
              onProfileTap: () => auth.isAuthenticated
                  ? ref.read(navigationProvider).goToProfile()
                  : ref.read(navigationProvider).goToOnboarding(),
            ),
            SizedBox(height: 3.h),
            const Expanded(child: _Body()),
          ],
        ),

        // ── FABs ──────────────────────────────────────────────────────────
        Positioned(
          bottom: 10.h,
          right: 5.w,
          child: FabStack(
            joinTap: () => ref.read(navigationProvider).openCodeSearch(),
            createTap: _onCreateRoom,
          ),
        ),

        // ── Slide-up drawer ───────────────────────────────────────────────
        const DrawerLayer(),
      ],
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent calls',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: MeetColors.dark,
              ),
            ),
            SizedBox(height: 1.5.h),
            ..._dummyCalls.asMap().entries.map(
                  (e) => _RecentCallTile(call: e.value, index: e.key),
                ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

// ─── Tile ─────────────────────────────────────────────────────────────────────









class _RecentCallTile extends ConsumerWidget {
  final RecentCall call;
  final int index;

  const _RecentCallTile({required this.call, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const maxAvatars = 3;
    final shown = call.participantInitials.take(maxAvatars).toList();
    final overflow = call.participantInitials.length - maxAvatars;

    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.15), width: 0.8),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            try {
              await ref
                  .read(callStateProvider.notifier)
                  .joinChannel(call.channelName);
              ref.read(navigationProvider).callScreen(call.channelName);
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Failed to rejoin call',
                      style: GoogleFonts.spaceGrotesk(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF2C2C2A),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            }
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                // ── Call icon ─────────────────────────────────────────────
                const Icon(
                  Icons.video_call_rounded,
                  color: Colors.black,
                  size: 30,
                ),
                const SizedBox(width: 12),

                // ── Channel name + meta ───────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.channelName,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: MeetColors.dark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            call.formattedDate,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12.sp,
                              color: MeetColors.light,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              '${call.participantInitials.length} joined',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11.sp,
                                color: MeetColors.mid,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

             SizedBox(width: 5.w),

                // ── Avatar stack ──────────────────────────────────────────
                SizedBox(
                  width: (shown.length + (overflow > 0 ? 1 : 0)) * 20.0 + 6,
                  height: 28,
                  child: Stack(
                    children: [
                      ...shown.asMap().entries.map((e) {
                        final colorIdx =
                            (index * 3 + e.key) % _avatarBgs.length;
                        return Positioned(
                          left: e.key * 20.0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _avatarBgs[colorIdx],
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                e.value,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: _avatarFgs[colorIdx],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      if (overflow > 0)
                        Positioned(
                          left: shown.length * 20.0,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                '+$overflow',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: MeetColors.mid,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (index * 60).ms, duration: 350.ms)
        .slideY(
          begin: 0.04,
          end: 0,
          delay: (index * 60).ms,
          duration: 350.ms,
        );
  }
}