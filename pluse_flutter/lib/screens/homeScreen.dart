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
              child: const AuthenticatedBody()
                  
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

           Lottie.asset(
          'assets/images/Video call chatting animation.json',
          fit: BoxFit.contain,
        ),
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

