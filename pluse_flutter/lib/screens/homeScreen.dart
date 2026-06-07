import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pluse_flutter/app/appshell.dart';
import 'package:pluse_flutter/core/enums.dart';
import 'package:pluse_flutter/core/theme/app_colors.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:pluse_flutter/providers/auth_provider.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';
import 'package:pluse_flutter/widget/loader.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';





final _drawerOpenProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (auth.isAuthenticating) return const LoadingScreen();

    // HomeScreen body never rebuilds due to drawer open/close
    return Stack(
      children: [
        // ── Main content ─────────────────────────────────────────
        Column(
          children: [
            SizedBox(height: 1.5.h),
            _TopBar(
              ctrl: _codeCtrl,
              onMenuTap: () =>
                  ref.read(_drawerOpenProvider.notifier).state = true,
              onCodeTap: () {
                FocusScope.of(context).unfocus();
               ref
    .read(navigationProvider)
    .openCodeSearch();
              },
              onProfileTap: () =>
                  ref
    .read(navigationProvider)
    .goToProfile()
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: auth.isAuthenticated
                  ? const _AuthenticatedBody()
                  : const _UnauthenticatedBody(),
            ),
          ],
        ),

        // ── FABs ─────────────────────────────────────────────────
        Positioned(
          bottom: 24,
          right: 20,
          child: _FabStack(
            joinTap: () => ref
    .read(navigationProvider)
    .openCodeSearch();
          ),
        ),

        // ── Overlay + Drawer — only these two rebuild on toggle ──
        const _DrawerLayer(),
      ],
    );
  }
}

// ─── DrawerLayer — its own Consumer so HomeScreen never rebuilds for it ───────

class _DrawerLayer extends ConsumerWidget {
  const _DrawerLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(_drawerOpenProvider);

    void close() => ref.read(_drawerOpenProvider.notifier).state = false;

    return Stack(
      children: [
        // Dim overlay
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: close,
              child: ColoredBox(
                color: Colors.black.withOpacity(0.45),
              ),
            ),
          ),

        // Drawer — always in tree, just off-screen when closed
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          top: 0,
          bottom: 0,
          left: isOpen ? 0 : -82.w,
          width: 82.w,
          child: _MeetDrawer(
            onClose: close,
            onSettingsTap: () {
              close();
              ref.read(navigationProvider).goToProfile();
            },
          ),
        ),
      ],
    );
  }
}

// ─── Drawer — const children, no animate() calls that can replay ──────────────

class _MeetDrawer extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSettingsTap;

  const _MeetDrawer({
    required this.onClose,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.5.h),

            Center(
              child: Text(
                'ELVES MEET',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: MeetColors.dark,
                ),
              ),
            ),

            SizedBox(height: 1.4.h),

            Divider(
              height: 1,
              thickness: 0.6,
              color: MeetColors.mid.withOpacity(0.18),
            ),

            SizedBox(height: 1.4.h),

            _DrawerItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy in Meet',
              onTap: () {},
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: onSettingsTap,
            ),
            _DrawerItem(
              icon: Icons.help_outline_rounded,
              title: 'Help & feedback',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 21, color: MeetColors.dark.withOpacity(0.9)),
            const SizedBox(width: 18),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: MeetColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Authenticated body ───────────────────────────────────────────────────────

class _AuthenticatedBody extends StatelessWidget {
  const _AuthenticatedBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          ...List.generate(
            3,
            (i) => Container(
              margin: EdgeInsets.only(bottom: 1.5.h),
              height: 72,
              decoration: BoxDecoration(
                color: MeetColors.surface,
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
    );
  }
}

// ─── Unauthenticated body ─────────────────────────────────────────────────────

class _UnauthenticatedBody extends StatelessWidget {
  const _UnauthenticatedBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/images/Video call chatting animation.json',
          fit: BoxFit.contain,
        ),

        SizedBox(height: 5.5.h),

        Text(
          'Select an account to do \nmore in Meet',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24.sp,
            fontWeight: FontWeight.w400,
            color: MeetColors.dark,
            height: 1.3,
            letterSpacing: -0.3,
          ),
        )
            .animate()
            .fadeIn(delay: 160.ms, duration: 400.ms)
            .slideY(begin: 0.05, end: 0, delay: 160.ms, duration: 400.ms),

        SizedBox(height: 1.5.h),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            'Add your account so you can start your own calls and use your contacts in Meet. Without an account, you can only join meetings created by others.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5.sp,
              color: MeetColors.mid,
              height: 1.65,
            ),
          )
              .animate()
              .fadeIn(delay: 220.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0, delay: 220.ms, duration: 400.ms),
        ),

        SizedBox(height: 14.h),
      ],
    );
  }
}

// ─── Top bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final TextEditingController ctrl;
  final VoidCallback onMenuTap;
  final VoidCallback onCodeTap;
  final VoidCallback onProfileTap;

  const _TopBar({
    required this.ctrl,
    required this.onMenuTap,
    required this.onCodeTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(
              Icons.menu_rounded,
              color: MeetColors.dark,
              size: 26,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: InkWell(
              onTap: onCodeTap,
              borderRadius: BorderRadius.circular(32),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 48,
                decoration: BoxDecoration(
                  color: MeetColors.surface,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter a code',
                    style: TextStyle(
                      color: MeetColors.mid,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MeetColors.bg,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: MeetColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms);
  }
}

// ─── FAB stack ───────────────────────────────────────────────────────────────

class _FabStack extends StatelessWidget {
  final VoidCallback joinTap;
  const _FabStack({required this.joinTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SquareFab(
          color: MeetColors.fabAcct,
          icon: Icons.manage_accounts_outlined,
          iconColor: MeetColors.primary,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _WideFab(
          color: MeetColors.fabJoin,
          label: 'Join',
          icon: Icons.video_call_outlined,
          onTap: joinTap,
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 400.ms)
        .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 400.ms);
  }
}

class _SquareFab extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SquareFab({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.onTap,
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
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 26),
      ),
    );
  }
}

class _WideFab extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _WideFab({
    required this.color,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: MeetColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: MeetColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}