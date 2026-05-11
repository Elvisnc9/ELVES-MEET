import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pluse_flutter/app/appshell.dart';
import 'package:pluse_flutter/core/theme/app_colors.dart';
import 'package:pluse_flutter/providers/auth_provider.dart';
import 'package:pluse_flutter/screens/profile.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

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
    'Video meeting for everyone',
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

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idx = ref.watch(_pageIdxProvider);

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _ctrl,
            itemCount: _pages.length,
            onPageChanged: (i) =>
                ref.read(_pageIdxProvider.notifier).state = i,
            itemBuilder: (_, i) => _Slide(page: _pages[i]),
          ),
        ),

        SizedBox(height: 2.h),
        _Dots(current: idx, count: _pages.length),
        SizedBox(height: 3.h),

        _BottomCard(
          // Google / Facebook → sign in then go home (authenticated)
          onSignIn: () async {
            await ref.read(authProvider.notifier).signIn();
            if (mounted) {
              ref.read(shellViewProvider.notifier).state = ShellView.home;
            }
          },
          // Guest → unauthenticated home
          onGuest: () {
            ref.read(authProvider.notifier).continueAsGuest();
            ref.read(shellViewProvider.notifier).state = ShellView.home;
          },
        ),
      ],
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
              fontSize: 30.sp,
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
            style: TextStyle(fontSize: 14.5.sp, color: MeetColors.mid, height: 1.6),
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

class _BottomCard extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onGuest;

  const _BottomCard({required this.onSignIn, required this.onGuest});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MeetColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

 AuthButton(
              text: 'Continue with Facebook',
              imageIcon: 'assets/images/facebook_logo.png',
              color: const Color(0xff4867AA),
              textColor: Colors.white,
              iconColor: Colors.white,
              onTap: onSignIn
            ),

            SizedBox(height: 1.5.h),

            AuthButton(
              text: 'Continue with Gmail',
              imageIcon: 'assets/images/google_logo.png',
              color: Colors.white,
              textColor: const Color(0xff444444),
              iconColor: const Color(0xff444444),
              onTap: onSignIn
            ),
         
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onGuest,
            child: const Text(
              'Use Meet without an account',
              style: TextStyle(
                color: MeetColors.primary,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          const Text(
            'By continuing, you agree to our Terms of Service and Privacy Policy.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: MeetColors.light),
          )
              .animate()
              .fadeIn(delay: 180.ms, duration: 400.ms)
              .slideY(begin: 0.06, end: 0, delay: 180.ms, duration: 400.ms),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 180.ms, duration: 400.ms)
        .slideY(begin: 0.06, end: 0, delay: 180.ms, duration: 400.ms);
  }
}

// ─── Auth button ─────────────────────────────────────────────────────────────

