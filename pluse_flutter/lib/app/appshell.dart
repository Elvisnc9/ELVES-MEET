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
    final overlay = ref.watch(overlayProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [

            /// ─── ROOT SCREENS ─────────────────────────────
AnimatedSwitcher(
  duration: const Duration(milliseconds: 600),
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
      RootScreen.profile    => const ProfileScreen(),
    },
  ),
),
            /// ─── OVERLAYS ─────────────────────────────────

            if (overlay != null)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),

                transitionBuilder:
                    (child, animation) {
                  final tween = Tween(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).chain(
                    CurveTween(
                      curve: Curves.easeInOut,
                    ),
                  );

                  return SlideTransition(
                    position:
                        animation.drive(tween),
                    child: child,
                  );
                },

                child: switch (overlay) {
                  OverlayScreen.codeSearch =>
                    const CodeSearchScreen(
                      key: ValueKey(
                        'codesearch',
                      ),
                    ),

                  // ignore: constant_pattern_never_matches_value_type
                  null => const SizedBox.shrink(),
                },
              ),
          ],
        ),
      ),
    );
  }
}





