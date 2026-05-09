import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:pluse_flutter/widget/transition_painter.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';
import 'package:video_player/video_player.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onNext;

  const OnboardingScreen({
    super.key,
    required this.onNext,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();


}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _introController;
  late final VideoPlayerController _videoController;

  bool _videoReady = false;
  

    late final PageController _pageController;

  Timer? _autoScrollTimer;

  int currentPage = 0;



   final List<_OnboardingPageData> pages = const [
    _OnboardingPageData(
      title: 'Video meetings with expressions',
      title2: '& personality',
      subtext:
          'Talk in real time and switch into avatar mode for a more personal calling experience.',
    ),
    _OnboardingPageData(
      title: 'More personal video conversations',
      title2: 'More naturally',
      subtext:
          'Enjoy smooth video conversations with expressive avatar features that bring more personality.',
    ),
    _OnboardingPageData(
      title: 'Talk naturally, appear differently',
      title2: 'With avatars',
      subtext:
          'Join seamless conversations and communicate through both real video and avatar presence.',
    ),
    _OnboardingPageData(
      title: 'Built for immersive conversations',
      title2: 'Presence & style',
      subtext:
          'Experience video calling with avatar-based interaction built for comfort and personality.',
    ),
  ];

  @override
  void initState() {
    super.initState();
 _pageController = PageController()
      ..addListener(() {
        if (!_pageController.hasClients) return;
        final nextPage = _pageController.page?.round() ?? 0;
        if (nextPage != currentPage && mounted) {
          setState(() {
            currentPage = nextPage;
          });
        }
      });
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _videoController = VideoPlayerController.asset(
      'assets/images/BackgroundVideo.mp4',
    );

    _videoController.initialize().then((_) {
      if (!mounted) return;

      _videoController
        ..setLooping(true)
        ..setVolume(0)
        ..play();

      setState(() {
        _videoReady = true;
      });

      _introController.forward();
      

      _introController.forward().then((_) {
  if (!mounted) return;
  _startAutoScroll();
});
    });
  }


  void _startAutoScroll() {
    _autoScrollTimer?.cancel();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_pageController.hasClients) return;

      final nextPage = (currentPage + 1) % pages.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
  _pageController.dispose();  // ADD
  _introController.dispose();
  _videoController.dispose();
    super.dispose();
  }

  double _interval(double start, double end, double value) {
    final result = ((value - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(result);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
    
        final phoneWidth = screenWidth < 430 ? screenWidth * 0.82 : 275.0;
        final phoneHeight = phoneWidth * 1.82;
    
        return AnimatedBuilder(
          animation: _introController,
          builder: (context, _) {
            final value = _introController.value;
            
            final sReveal = _interval(0.15, 0.88, value);
            final titleReveal = _interval(0.25, 0.58, value);
            final panelReveal = _interval(0.55, 1.00, value);
            
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color:  Colors.white,
                  ),
                ),
                        
                Positioned(
                  left: 0,
                  right: 0,
                  top: phoneHeight * 0.20,
                  height: phoneHeight * 0.62,
                  child: Stack(
                    children: [
                      if (_videoReady)
                        ClipPath(
                          clipper: SVideoRevealClipper(
                            progress: sReveal,
                          ),
                          child: SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width:
                                    _videoController.value.size.width,
                                height:
                                    _videoController.value.size.height,
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                          ),
                        ),
                        
                      // Positioned.fill(
                      //   child: CustomPaint(
                      //     painter: SBrandRibbonPainter(
                      //       progress: sReveal,
                      //       color: const Color(0xFF171820),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                        
                        
               
                        
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: phoneHeight * 0.56,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      phoneHeight * 0.54 * (1 - panelReveal),
                    ),
                    child: _BlueIntroPanel(
                      progress: panelReveal,
                      onNext: widget.onNext,
                        currentPage: currentPage,   // ADD
                        pages: pages,  
                        pageController: _pageController
            
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _BlueIntroPanel extends StatelessWidget {
  final double progress;
  final VoidCallback onNext;
    final int currentPage;               // ADD
  final List<_OnboardingPageData> pages;
  final PageController pageController;

  const _BlueIntroPanel({
    required this.progress,
    required this.onNext, required this.currentPage, required this.pages, required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final contentOpacity = Curves.easeOut.transform(progress);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
        Positioned(
  left: 0,
  right: 0,
  top: 28,
  height: 200, // constrain it so it doesn't fight the Stack
  child: Opacity(
    opacity: contentOpacity,
    child: PageView.builder(
      controller: pageController,
      itemCount: pages.length,
      itemBuilder: (context, idx) => PageSlider(
        title: pages[idx].title,
        title2: pages[idx].title2,
        subtext: pages[idx].subtext,
      ),
    ),
  ),
),

         Positioned(
        
          left: 0,
          right: 0,
          bottom: 10,
          child: Button(onTap: onNext).animate().fadeIn(delay: 1.2.seconds, duration: 600.ms)),

        
        ],
      ),
    );
  }
}





class _OnboardingPageData {
  final String title;
  final String title2;
  final String subtext;

  const _OnboardingPageData({
    required this.title,
    required this.title2,
    required this.subtext,
  });
}

class PageSlider extends StatelessWidget {
  const PageSlider({
    super.key,
    required this.title,
    required this.title2,
    required this.subtext,
  });

  final String title;
  final String title2;
  final String subtext;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$title\n",
                  style: textTheme.displayLarge?.copyWith(
                    fontSize: 35.sp,
                    color: Colors.white,
                    height: 1.18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: title2,
                  style: textTheme.displayLarge?.copyWith(
                    fontSize: 40.sp,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .slideX(
                begin: 0.18,
                end: 0,
                duration: 420.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: 280.ms),

          const SizedBox(height: 16),

          Text(
            subtext,
            textAlign: TextAlign.center,
            style: textTheme.labelMedium?.copyWith(
              fontSize: 12.sp,
              color: Colors.white70,
              height: 1.45,
            ),
          )
              .animate()
              .fadeIn(delay: 120.ms, duration: 350.ms)
              .slideY(begin: 0.15, end: 0),
        ],
      ),
    );
  }
}





class Button extends StatelessWidget {
  final VoidCallback onTap;
 

  const Button({
    super.key,
    required this.onTap,
  
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            SizedBox(width: 3.w),
            const Text(
              "Get Started Now",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}