import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';


 
const _bg      = Color(0xFFECEDF6);
const _cardBg  = Color(0xFFF3F4FB);
const _surface = Colors.white;
const _primary = Color(0xFF3B4B8C);
const _dark    = Color(0xFF1A1A2E);
const _mid     = Color(0xFF4B5160);
const _light   = Color(0xFF8A8FA8);
const _divider = Color(0xFFE4E6F0);
const _dotOn   = Color(0xFF3B4B8C);
const _dotOff  = Color(0xFFCDD0E0);
 
// ─── Data ────────────────────────────────────────────────────────────────────
 
class _Page {
  final String title;
  final String subtitle;
  final String lottiePath;
  const _Page(this.title, this.subtitle, this.lottiePath);
}
 
const _pages = [
  _Page(
    'Welcome to Elves Meet',
    'Make video calls to friends and family or create and join meetings, all in one app',
    'assets/images/Video call chatting animation.json',
  
  ),
  _Page(
    'Rich video meetings for everyone to join',
    'Schedule time to connect when everyone can join, and use virtual backgrounds, chat, captions and live sharing',
      'assets/images/Video call chatting animation.json',
  ),
];
 
// ─── Provider ────────────────────────────────────────────────────────────────
 
final _pageIdxProvider = StateProvider<int>((ref) => 0);
 
// ─── Screen ──────────────────────────────────────────────────────────────────
 
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
 
  @override
  ConsumerState<OnboardingScreen> createState() => _State();
}
 
class _State extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
 
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final idx = ref.watch(_pageIdxProvider);
 
    return  Column(
          children: [
            // Pager
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: _pages.length,
                onPageChanged: (i) =>
                    ref.read(_pageIdxProvider.notifier).state = i,
                itemBuilder: (_, i) => _Slide(page: _pages[i]),
              ),
            ),

            SizedBox(height: 2.h),
            // Dots
            _Dots(current: idx, count: _pages.length),
 
             SizedBox(height: 3.h),
 
            // Bottom card
            const _BottomCard(),
          ],
      
      
    );
  }
}
 
// ─── Slide ───────────────────────────────────────────────────────────────────
 
class _Slide extends StatelessWidget {
  final _Page page;
  const _Slide({required this.page});
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 8),
 
          Text(
            page.title,
            textAlign: TextAlign.center,
            style:  GoogleFonts.spaceGrotesk(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: _dark,
              height: 1.25,
              letterSpacing: -0.4,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05, end: 0, duration: 400.ms),
 
          const SizedBox(height: 14),
 
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14.5, color: _mid, height: 1.6),
          )
              .animate()
              .fadeIn(delay: 60.ms, duration: 400.ms)
              .slideY(begin: 0.05, end: 0, delay: 60.ms, duration: 400.ms),
 
        
 
          // ── Lottie slot ──────────────────────────────────────────
          // Replace the Container below with:


         Expanded(
           child: Transform.scale(
            scale: 1.45,
             child: Lottie.asset(page.lottiePath,
             height: 65.h, fit: BoxFit.contain),
           ),
         )
         
            
             
       
        ],
      ),
    );
  }
}
 
// ─── Dots ────────────────────────────────────────────────────────────────────
 
class _Dots extends StatelessWidget {
  final int current;
  final int count;
  const _Dots({required this.current, required this.count});
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? _dotOn : _dotOff,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
 
// ─── Bottom card ─────────────────────────────────────────────────────────────
 
class _BottomCard extends StatelessWidget {
  const _BottomCard();
 
  @override
  Widget build(BuildContext context) {
  
 
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow:[
          BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      padding: EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Account row
          AuthButton(
            onpress: () {},
            text: 'Continue With Google',
            socialogo: 'assets/images/google_logo.png',
          ),
          const SizedBox(height: 16),
 
          // CTA button
          AuthButton(
            onpress: () {},
            text: 'Continue as Facebook',
            socialogo: 'assets/images/facebook_logo.png',
          ),
 
          const SizedBox(height: 14),
 
          // Guest link
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Use Meet without an account',
              style: TextStyle(color: _primary, fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
          ),
 
           SizedBox(height: 4.h),
 
          // Legal links
          Text('By continuing, you agree to our Terms of Service and Privacy Policy.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: _light))
              .animate()
              .fadeIn(delay: 180.ms, duration: 400.ms)
              .slideY(begin: 0.06, end: 0, delay: 180.ms, duration: 400.ms),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 180.ms, duration: 400.ms)
        .slideY(begin: 0.06, end: 0, delay: 180.ms, duration: 400.ms);
  }
}

class AuthButton extends StatelessWidget {
  final VoidCallback onpress;
  final String text;
  final String socialogo;
  const AuthButton({
    super.key,
    required this.onpress,
    required this.text,
    required this.socialogo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onpress,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              socialogo,
              height: 24,
            ),
             const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}