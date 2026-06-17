import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pluse_flutter/widget/authButton.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

import 'package:pluse_flutter/core/theme/app_colors.dart';
import 'package:pluse_flutter/providers/auth_provider.dart';

// ─── Data ────────────────────────────────────────────────────────────────────

class _Page {
  final String title;
  final String subtitle;
  final String lottiePath;
  const _Page(this.title, this.subtitle, this.lottiePath);
}

const _pages = [
  _Page(
    'Welcome to Elves Meet',
    'Make video calls to friends and family or create and join meetings, all in one app',
    'assets/images/Video call chatting animation.json',
  ),
  _Page(
    'Bring Everyone Together',
    'Schedule a time that works for everyone, with virtual backgrounds and live sharing',
    'assets/images/Video call chatting animation.json',
  ),
  _Page(
    'Connect Beyond Distance',
    'Schedule a time that works for everyone, with virtual backgrounds and live sharing',
    'assets/images/Video call chatting animation.json',
  ),
];

// ─── Provider ────────────────────────────────────────────────────────────────

final _pageIdxProvider = StateProvider<int>((ref) => 0);

// ─── Screen ──────────────────────────────────────────────────────────────────

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _State();
}

class _State extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  bool _isSigningIn = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2C2C2A),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFF09595),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign in failed',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD3D1C7),
                    ),
                  ),
                  Text(
                    message,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: const Color(0xFF888780),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (_isSigningIn) return;
    setState(() => _isSigningIn = true);

    final nav = ref.read(navigationProvider);
    final auth = ref.read(authProvider.notifier);

    try {
      await auth.signInWithGoogle();
      nav.goToLoading();
    } catch (e) {
      setState(() => _isSigningIn = false);

      // Parse a friendly message from the error
      final raw = e.toString().toLowerCase();
      String friendlyMsg;
      if (raw.contains('cancel') || raw.contains('user_canceled')) {
        friendlyMsg = 'Sign-in was cancelled.';
      } else if (raw.contains('network') || raw.contains('socket')) {
        friendlyMsg = 'No internet connection. Check your network.';
      } else if (raw.contains('token')) {
        friendlyMsg = 'Could not get a token from Google. Try again.';
      } else {
        friendlyMsg = 'Could not authenticate with Google. Try again.';
      }

      _showErrorSnackbar(friendlyMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final idx = ref.watch(_pageIdxProvider);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 28 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: PageView.builder(
              controller: _ctrl,
              itemCount: _pages.length,
              onPageChanged: (i) =>
                  ref.read(_pageIdxProvider.notifier).state = i,
              itemBuilder: (_, i) => _Slide(page: _pages[i]),
            ),
          ),

          SizedBox(height: 1.h),
          _Dots(current: idx, count: _pages.length),
          SizedBox(height: 2.h),

          BottomCard(
            onSignIn: _handleSignIn,
            isSigningIn: _isSigningIn,
          ),
        ],
      ),
    );
  }
}

// ─── Slide ───────────────────────────────────────────────────────────────────

class _Slide extends StatelessWidget {
  final _Page page;
  const _Slide({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          SizedBox(height: 3.h),

          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
              color: MeetColors.dark,
              height: 1.25,
              letterSpacing: -0.4,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05, end: 0, duration: 400.ms),

          const SizedBox(height: 14),

          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              color: MeetColors.mid,
              height: 1.6,
            ),
          )
              .animate()
              .fadeIn(delay: 60.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0, delay: 60.ms, duration: 400.ms),

          Expanded(
            child: Transform.scale(
              scale: 1.5,
              child: Lottie.asset(page.lottiePath, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dots ────────────────────────────────────────────────────────────────────

class _Dots extends StatelessWidget {
  final int current;
  final int count;
  const _Dots({required this.current, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? MeetColors.dotOn : MeetColors.dotOff,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─── Bottom card ─────────────────────────────────────────────────────────────

class BottomCard extends StatelessWidget {
  final VoidCallback onSignIn;
  final bool isSigningIn;

  const BottomCard({
    super.key,
    required this.onSignIn,
    this.isSigningIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: const BoxDecoration(
          color: MeetColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: AuthButtonPack(
          onSignIn: onSignIn,
          isSigningIn: isSigningIn,
        ),
      )
          .animate()
          .fadeIn(delay: 180.ms, duration: 400.ms)
          .slideY(begin: 0.06, end: 0, delay: 180.ms, duration: 400.ms),
    );
  }
}

class AuthButtonPack extends StatelessWidget {
  const AuthButtonPack({
    super.key,
    required this.onSignIn,
    required this.isSigningIn,
  });

  final VoidCallback onSignIn;
  final bool isSigningIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthButton(
          text: 'Continue with Facebook',
          icon: Icons.facebook_rounded,
          color: const Color(0xff4867AA),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: () {},
          isloading: false,
        ),

        SizedBox(height: 1.5.h),

        AuthButton(
          text: 'Continue with Gmail',
          imageIcon: 'assets/images/google_logo.png',
          color: Colors.white,
          textColor: const Color(0xff444444),
          iconColor: const Color(0xff444444),
          onTap: onSignIn,
          isloading: isSigningIn,
        ),

        const SizedBox(height: 14),

        GestureDetector(
          child: const Text(
            'Get Started With Elves Meet',
            style: TextStyle(
              color: MeetColors.primary,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        Text(
          'By continuing, you agree to our Terms of Service and Privacy Policy.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: MeetColors.light),
        )
            .animate()
            .fadeIn(delay: 180.ms, duration: 400.ms)
            .slideY(begin: 0.06, end: 0, delay: 180.ms, duration: 400.ms),
      ],
    );
  }
}