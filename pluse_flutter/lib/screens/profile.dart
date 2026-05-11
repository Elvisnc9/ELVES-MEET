import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluse_flutter/app/appshell.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xffFAFAEF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
      
            Row(
              children: [
                _CircleIcon(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () {
                    ref.read(shellViewProvider.notifier).state = ShellView.home;
                  },
                ),
      
                const Spacer(),
      
                Text(
                  'Profile',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff111111),
                  ),
                ),
      
                const Spacer(),
      
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/google_logo.png'),
                ),
              ],
            ),
      
            SizedBox(height: 3.h),
      
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xff111111),
                          ),
                        ),
      
                        const SizedBox(height: 5),
      
                        Text(
                          'Compare, combine and book\nnew routes.',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            height: 1.35,
                            color: const Color(0xff7B7B6E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      
                SizedBox(
                  width: 120,
                  height: 95,
                  child: Transform.scale(
                    scale: 1.9,
                    child: Lottie.asset(
                      'assets/images/Video meeting.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
      
            SizedBox(height: 1.5.h),
      
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(22),
            //   child: Image.asset(
            //     'assets/images/promo_banner.png',
            //     width: double.infinity,
            //     height: 74,
            //     fit: BoxFit.cover,
            //   ),
            // ),
      
            SizedBox(height: 3.h),
      
            Text(
              'Settings',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xff111111),
              ),
            ),
      
            SizedBox(height: 1.5.h),
      
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.confirmation_number_outlined,
                  iconBg: const Color(0xffFFE800),
                  iconColor: const Color(0xff1A1A1A),
                  title: 'Tickets & Trips',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.person_outline_rounded,
                  iconBg: const Color(0xffBDF3F2),
                  iconColor: const Color(0xff0098A8),
                  title: 'Profile',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.credit_card_rounded,
                  iconBg: const Color(0xffDDF4B6),
                  iconColor: const Color(0xff70A800),
                  title: 'Payment Methods',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.business_center_outlined,
                  iconBg: const Color(0xffCFE2FF),
                  iconColor: const Color(0xff407BFF),
                  title: 'wegfinder for Business',
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
      
            SizedBox(height: 2.h),
      
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  iconBg: const Color(0xffCFF7F1),
                  iconColor: const Color(0xff18A999),
                  title: 'Help & Feedback',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconBg: const Color(0xffFFF3B8),
                  iconColor: const Color(0xffB49A00),
                  title: 'About',
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
      
            SizedBox(height: 2.h),
      
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  iconBg: const Color(0xffFFE6E6),
                  iconColor: const Color(0xffFF4D4D),
                  title: 'Log Out',
                  titleColor: const Color(0xffFF4D4D),
                  arrowColor: const Color(0xffFF4D4D),
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Color(0xffF1F1E6),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 17,
          color: const Color(0xff111111),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final Color? arrowColor;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.arrowColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? const Color(0xff333333),
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: arrowColor ?? const Color(0xff111111),
                ),
              ],
            ),
          ),
        ),

        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 62, right: 14),
            child: Divider(
              height: 1,
              thickness: 0.6,
              color: const Color(0xffE8E8DE).withOpacity(0.8),
            ),
          ),
      ],
    );
  }
}




class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10),
      child: Column(
        children: [

           Align(
            alignment: Alignment.centerLeft,
             child: GestureDetector(
               onTap: () {
                      ref.read(shellViewProvider.notifier).state = ShellView.home;
                    },
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    size: 30,
                    color: const Color(0xff111111),
                  ),
                ),
           ),
      
          const Spacer(),
    
          Transform.scale(
            scale: 2.5,
            child: Lottie.asset(
              'assets/images/Video call chatting animation.json',
              width: 145,
              height: 145,
              fit: BoxFit.contain,
            ),
          ),
    
          SizedBox(height: 2.5.h),
    
          Text(
            'Sign in',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 35.sp,
              fontWeight: FontWeight.bold,
              color:  Colors.black,
              letterSpacing: -1,
            ),
          ),
    
          SizedBox(height: 3.h),
    
          _AuthButton(
            text: 'Continue with Facebook',
            icon: Icons.facebook_rounded,
            color: const Color(0xff4867AA),
            textColor: Colors.white,
            iconColor: Colors.white,
            onTap: () {},
          ),
    
          SizedBox(height: 1.5.h),
    
          _AuthButton(
            text: 'Continue with Gmail',
            imageIcon: 'assets/images/google_logo.png',
            color: Colors.white,
            textColor: const Color(0xff444444),
            iconColor: const Color(0xff444444),
            onTap: () {},
          ),
    
          SizedBox(height: 1.5.h),
    
          _AuthButton(
            text: 'Login with Email',
            icon: Icons.email_outlined,
            color: const Color(0xffFF5A3D),
            textColor: Colors.white,
            iconColor: Colors.white,
            onTap: () {},
          ),
    
          SizedBox(height: 2.h),
    
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don’t have account? Please ',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14.sp,
                  color: const Color(0xffA0A0A0),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Sign up',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffFF5A3D),
                  ),
                ),
              ),
            ],
          ),
    
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? imageIcon;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _AuthButton({
    required this.text,
    required this.color,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
    this.icon,
    this.imageIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 25,
                child: imageIcon != null
                    ? Image.asset(
                        imageIcon!,
                        width: 25,
                        height: 25,
                      )
                    : Icon(
                        icon,
                        size: 30,
                        color: iconColor,
                      ),
              ),
      
              Text(
                text,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}