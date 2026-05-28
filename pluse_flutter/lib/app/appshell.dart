import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:pluse_flutter/screens/codeSearch.dart';
import 'package:pluse_flutter/screens/homeScreen.dart';
import 'package:pluse_flutter/screens/onboardiing.dart';
import 'package:pluse_flutter/screens/profile.dart';
import 'package:pluse_flutter/widget/loader.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentView = ref.watch(shellViewProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),

          transitionBuilder: (Widget child, Animation<double> animation) {
            final isCodeSearch = child.key == const ValueKey('codesearch');

            // CodeSearch behaves more naturally from Home
            final beginOffset = isCodeSearch
                ? const Offset(1.0, 0.0) // comes from right
                : const Offset(-1.0, 0.0); // other pages from left

            final tween =
                Tween(
                  begin: beginOffset,
                  end: Offset.zero,
                ).chain(
                  CurveTween(
                   curve:  Curves.easeIn
                  ),
                );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },

          child: switch (currentView) {
            ShellView.onboarding => const OnboardingScreen(
              key: ValueKey('onboarding'),
            ),

            ShellView.loading => const LoadingScreen(
              key: ValueKey('loading'),
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
  loading, // ← dedicated loading shell — owns the slide transition
  home,
  codesearch,
  profile,
}

final shellViewProvider = StateProvider<ShellView>(
  (ref) => ShellView.onboarding,
);
