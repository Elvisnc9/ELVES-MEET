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
import 'package:pluse_flutter/providers/navigation_controller.dart';
import 'package:pluse_flutter/screens/createroom.dart';
import 'package:pluse_flutter/widget/home_widget/FabButton.dart';
import 'package:pluse_flutter/widget/home_widget/drawer.dart';
import 'package:pluse_flutter/widget/home_widget/topbar.dart';
import 'package:pluse_flutter/widget/loader.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

final drawerOpenProvider = StateProvider<bool>((ref) => false);

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
    // Request camera & microphone permissions as soon as the home screen loads
    // so the user isn't surprised when they try to join a call.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await [Permission.camera, Permission.microphone].request();
    });
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  /// Generates a channel name, stores it, fakes a "creating" delay,
  /// then opens the panel ready for the user to copy / join.
  Future<void> _onCreateRoom() async {
    final channelName = generateChannelName();

    // Store generated channel name BEFORE showing the panel
    ref.read(createdChannelProvider.notifier).state = channelName;

    // Show loading state inside the panel
    ref.read(createRoomLoadingProvider.notifier).state = true;
    ref.read(createRoomPanelProvider.notifier).state = true;

    // Simulate a brief "room creation" moment (no actual server call needed
    // since Agora creates channels on first join)
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

        // ── FABs ────────────────────────────────────────────────────────
        Positioned(
          bottom: 10.h,
          right: 5.w,
          child: FabStack(
            joinTap: () => ref.read(navigationProvider).openCodeSearch(),
            createTap: _onCreateRoom,
          ),
        ),

        // ── Slide-up drawer ──────────────────────────────────────────────
        const DrawerLayer(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────




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

            // Placeholder skeleton cards
            ...List.generate(
              10,
              (i) => Container(
                margin: EdgeInsets.only(bottom: 1.5.h),
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
              )
                  .animate()
                  .fadeIn(delay: (i * 60).ms, duration: 350.ms)
                  .slideY(
                    begin: 0.04,
                    end: 0,
                    delay: (i * 60).ms,
                    duration: 350.ms,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}