import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:pluse_flutter/screens/codeSearch.dart';
import 'package:pluse_flutter/screens/homeScreen.dart';
import 'package:pluse_flutter/screens/onboardiing.dart';
import 'package:pluse_flutter/screens/profile.dart';
import 'package:pluse_flutter/widget/loader.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootScreen = ref.watch(rootScreenProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [

            /// ─── ROOT SCREENS ─────────────────────────────
AnimatedSwitcher(
  duration: const Duration(milliseconds: 200),
  transitionBuilder: (child, animation) {
    final tween = Tween(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    ));
    return SlideTransition(position: tween, child: child);
  },
  child: KeyedSubtree(
    key: ValueKey(rootScreen),
    child: switch (rootScreen) {
      
      RootScreen.onboarding => const OnboardingScreen(),
      RootScreen.loading    => const LoadingScreen(),
      RootScreen.home       => const HomeScreen(),
      RootScreen.codeSearch => const CodeSearchScreen(),
      RootScreen.profile    => const ProfileScreen(),
    },
  ),
),
            /// ─── OVERLAYS ─────────────────────────────────

          
          ],
        ),
      ),
    );
  }
}





