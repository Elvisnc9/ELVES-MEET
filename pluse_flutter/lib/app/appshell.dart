import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: currentView == ShellView.onboarding
                    ? OnboardingScreen(
                        key: const ValueKey('onboarding'),
                      
                      )
                    : const HomeScreen(
                        key: ValueKey('home'),
                      ),
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
}

final shellViewProvider = StateProvider<ShellView>(
  (ref) => ShellView.onboarding,
);