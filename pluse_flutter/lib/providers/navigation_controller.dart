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





/// ─────────────────────────────────────────────────────
/// NAVIGATION CONTROLLER
/// ─────────────────────────────────────────────────────

class NavigationController {
  final Ref ref;

  NavigationController(this.ref);





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
        .read(overlayProvider.notifier)
        .state = OverlayScreen.codeSearch;
  }

  void closeOverlay() {
    ref
        .read(overlayProvider.notifier)
        .state = null;
  }





  /// ─── BACK NAVIGATION ──────────────────────────────

  void goBack() {
    final overlay =
        ref.read(overlayProvider);

    /// Close overlay first
    if (overlay != null) {
      closeOverlay();
      return;
    }

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