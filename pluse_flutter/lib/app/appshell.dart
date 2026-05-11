import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:pluse_flutter/screens/codeSearch.dart';
import 'package:pluse_flutter/screens/homeScreen.dart';
import 'package:pluse_flutter/screens/onboardiing.dart';


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
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
child: currentView == ShellView.onboarding
    ? OnboardingScreen(
        key: const ValueKey('onboarding'),
      )
    : currentView == ShellView.home
        ? const HomeScreen(
            key: ValueKey('home'),
          )
        : CodeSearchScreen(
           
          )
              ),
            ),
        
          
          ],
        ),
      ),
    );
  }
}



enum ShellView {
  onboarding,
  home,
  codesearch
}

final shellViewProvider = StateProvider<ShellView>(
  (ref) => ShellView.onboarding,
);