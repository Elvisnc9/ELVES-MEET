import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';





/// ─────────────────────────────────────────────────────
/// ROOT SCREENS
/// ─────────────────────────────────────────────────────

enum RootScreen {
  onboarding,
  loading,
  home,
  profile,
  codeSearch,
  call,
}

final rootScreenProvider =
    StateProvider<RootScreen>(
  (ref) => RootScreen.onboarding,
);





/// ─────────────────────────────────────────────────────
/// OVERLAYS
/// ─────────────────────────────────────────────────────







/// ─────────────────────────────────────────────────────
/// NAVIGATION CONTROLLER
/// ─────────────────────────────────────────────────────

class NavigationController {
  final Ref ref;

  NavigationController(this.ref);


final drawerOpenProvider = StateProvider<bool>((ref) => false);


  /// ─── ROOT NAVIGATION ──────────────────────────────

  void goToHome() {
    ref
        .read(rootScreenProvider.notifier)
        .state = RootScreen.home;
  }

  void goToProfile() {
    ref
        .read(rootScreenProvider.notifier)
        .state = RootScreen.profile;
  }

  void callScreen(String meetingId) {
    ref
        .read(rootScreenProvider.notifier)
        .state = RootScreen.call;
  }

  void goToLoading() {
    ref
        .read(rootScreenProvider.notifier)
        .state = RootScreen.loading;
  }

  void goToOnboarding() {
    ref
        .read(rootScreenProvider.notifier)
        .state = RootScreen.onboarding;
  }





  /// ─── OVERLAYS ─────────────────────────────────────

  void openCodeSearch() {
    ref
        .read(rootScreenProvider.notifier)
        .state = RootScreen.codeSearch;
  }

  





  /// ─── BACK NAVIGATION ──────────────────────────────

  void goBack() {
 

    /// Close overlay first
 

    /// Optional root fallback
    final root =
        ref.read(rootScreenProvider);

    if (root == RootScreen.profile) {
      goToHome();
    }
  }
}





final navigationProvider =
    Provider<NavigationController>(
  (ref) => NavigationController(ref),
);