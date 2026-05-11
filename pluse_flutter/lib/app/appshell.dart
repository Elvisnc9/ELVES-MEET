import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:pluse_flutter/screens/codeSearch.dart';
import 'package:pluse_flutter/screens/homeScreen.dart';
import 'package:pluse_flutter/screens/onboardiing.dart';
import 'package:pluse_flutter/screens/profile.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentView = ref.watch(shellViewProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 120),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            // codesearch snaps in instantly — no overlap with home drawer
            if (child.key == const ValueKey('codesearch')) return child;
            return FadeTransition(opacity: animation, child: child);
          },
          child: switch (currentView) {
            ShellView.onboarding => const OnboardingScreen(
                key: ValueKey('onboarding'),
              ),
            ShellView.home => const HomeScreen(
                key: ValueKey('home'),
              ),
            ShellView.codesearch => const CodeSearchScreen(
                key: ValueKey('codesearch'),
              ),
            ShellView.profile => const ProfileScreen(
                key: ValueKey('profile'),
              ),
          },
        ),
      ),
    );
  }
}

// ─── Shell views ─────────────────────────────────────────────────────────────

enum ShellView {
  onboarding,
  home,
  codesearch,
  profile,
}

final shellViewProvider = StateProvider<ShellView>(
  (ref) => ShellView.onboarding,
);