// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluse_flutter/core/enums.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:pluse_flutter/providers/auth_provider.dart';
import 'package:pluse_flutter/screens/callScreen.dart';
import 'package:pluse_flutter/screens/codeSearch.dart';
import 'package:pluse_flutter/screens/createroom.dart';
import 'package:pluse_flutter/screens/homeScreen.dart';
import 'package:pluse_flutter/screens/onboardiing.dart';
import 'package:pluse_flutter/screens/profile.dart';
import 'package:pluse_flutter/widget/loader.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}


class _AppShellState extends ConsumerState<AppShell> {


  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
   final isLoggedIn = ref.read(isLoggedInProvider);
    if (isLoggedIn) {
      ref.read(authProvider.notifier).state = AuthStatus.authenticated;
      ref.read(rootScreenProvider.notifier).state = RootScreen.home;
    } else {
      ref.read(rootScreenProvider.notifier).state = RootScreen.onboarding;
    }
  });
  }
  @override
  Widget build(BuildContext context) {
    final rootScreen = ref.watch(rootScreenProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [

           
            /// ─── ROOT SCREENS ─────────────────────────────
AnimatedSwitcher(
  duration: const Duration(milliseconds: 50),
  child: KeyedSubtree(
    key: ValueKey(rootScreen),
    child: switch (rootScreen) {
      RootScreen.onboarding => const OnboardingScreen(),
      RootScreen.loading    => const LoadingScreen(),
      RootScreen.home       => const HomeScreen(),
      RootScreen.call => const CallScreen(),
      RootScreen.codeSearch => const CodeSearchScreen(),
      RootScreen.profile    => const ProfileScreen(),
    },
  ),
),
            /// ─── OVERLAYS ─────────────────────────────────
 const CreateRoomPanel(),
          
          ],
        ),
      ),
    );
  }
}





