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
    final rootScreen = ref.watch(rootScreenProvider);
    final overlay = ref.watch(overlayProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [

            /// ─── ROOT SCREENS ─────────────────────────────

            IndexedStack(
              index: rootScreen.index,
              children: const [
                OnboardingScreen(),
                LoadingScreen(),
                HomeScreen(),
                ProfileScreen(),
              ],
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






/// ─────────────────────────────────────────────────────
/// ROOT SCREENS
/// ─────────────────────────────────────────────────────

enum RootScreen {
  onboarding,
  loading,
  home,
  profile,
}

final rootScreenProvider =
    StateProvider<RootScreen>(
  (ref) => RootScreen.onboarding,
);






/// ─────────────────────────────────────────────────────
/// OVERLAYS
/// ─────────────────────────────────────────────────────

enum OverlayScreen {
  codeSearch,
}

final overlayProvider =
    StateProvider<OverlayScreen?>(
  (ref) => null,
);