import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pluse_flutter/screens/meeting_detail.dart';
import 'package:pluse_flutter/screens/onboardiing.dart';
import 'package:pluse_flutter/widget/transition_painter.dart';


class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wipeController;

  bool _isWiping = false;
  bool _hasSwitchedToHome = false;

  @override
  void initState() {
    super.initState();

    _wipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1350),
    );

    _wipeController.addListener(() {
      if (_wipeController.value >= 0.48 && !_hasSwitchedToHome) {
        _hasSwitchedToHome = true;
        ref.read(shellViewProvider.notifier).state = ShellView.home;
      }
    });

    _wipeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isWiping = false;
        });
        _wipeController.reset();
      }
    });
  }

  void _goToHomeWithSWipe() {
    if (_isWiping) return;

    setState(() {
      _isWiping = true;
      _hasSwitchedToHome = false;
    });

    _wipeController.forward(from: 0);
  }

  @override
  void dispose() {
    _wipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentView = ref.watch(shellViewProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: currentView == ShellView.onboarding
                  ? OnboardingScreen(
                      key: const ValueKey('onboarding'),
                      onNext: _goToHomeWithSWipe,
                    )
                  : const MeetingHomeScreen(
                      key: ValueKey('home'),
                    ),
            ),
          ),

          if (_isWiping)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _wipeController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: PremiumSWipePainter(
                        progress: _wipeController.value,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
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