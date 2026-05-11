import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:pluse_flutter/screens/codeSearch.dart';
import 'package:pluse_flutter/screens/homeScreen.dart';
import 'package:pluse_flutter/screens/onboardiing.dart';
import 'package:pluse_flutter/screens/profile.dart';


class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final currentView = ref.watch(shellViewProvider);

    return Scaffold(
      backgroundColor:  Color(0xffFAFAEF),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 80),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            // Code search and settings snap in instantly — no sluggish transition
            final noAnim = child.key == const ValueKey('codesearch') ||
                child.key == const ValueKey('settings');
            if (noAnim) return child;
            return FadeTransition(opacity: animation, child: child);
          },
          child: switch (currentView) {
            ShellView.onboarding => OnboardingScreen(
                key: const ValueKey('onboarding'),
              ),
            ShellView.home => const HomeScreen(
                key: ValueKey('home'),
              ),
            ShellView.codesearch => CodeSearchScreen(
                key: const ValueKey('codesearch'),
             
              ),
            ShellView.profile => SignInScreen(
                key: const ValueKey('profile'),
                // onBack: () => ref.read(shellViewProvider.notifier).state =
                //     ShellView.home,
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



