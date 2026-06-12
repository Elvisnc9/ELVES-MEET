import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pluse_flutter/core/enums.dart';
import 'package:pluse_flutter/core/theme/app_colors.dart';
import 'package:pluse_flutter/providers/auth_provider.dart' hide navigationProvider;
import 'package:pluse_flutter/providers/navigation_controller.dart';
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
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
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
              onProfileTap: () =>
              auth.isAuthenticated?
                  ref.read(navigationProvider).goToProfile() :
                  ref.read(navigationProvider).goToOnboarding(),
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: auth.isAuthenticated
                  ? const AuthenticatedBody()
                  : const UnauthenticatedBody(),
            ),
          ],
        ),
        Positioned(
          bottom: 10.h,
          right: 5.w,
          child: FabStack(
            joinTap: () => ref.read(navigationProvider).openCodeSearch(),
          ),
        ),
        const DrawerLayer(),
      ],
    );
  }
}


class AuthenticatedBody extends StatelessWidget {
  const AuthenticatedBody({super.key});

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

class UnauthenticatedBody extends StatelessWidget {
  const UnauthenticatedBody({super.key});

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
            style: GoogleFonts.spaceGrotesk(
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