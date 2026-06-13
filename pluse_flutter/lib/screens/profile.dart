import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pluse_flutter/providers/auth_provider.dart' hide navigationProvider;
import 'package:pluse_flutter/providers/navigation_controller.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

// ─── Entry point — picks view based on auth state ─────────────────────────────

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(navigationProvider);
    
         return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
    
          // Top bar
          Row(
            children: [
              CircleIcon(
                icon: Icons.arrow_back_rounded,
                onTap: () => ref.read(navigationProvider).goToHome()
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
    
          // Welcome row + lottie
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
                        'Manage your account\nand preferences.',
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
    
          _SettingsCard(children: [
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
              icon: Icons.notifications_none_rounded,
              iconBg: const Color(0xffCFE2FF),
              iconColor: const Color(0xff407BFF),
              title: 'Notifications',
              onTap: () {},
              showDivider: false,
            ),
          ]),
    
          SizedBox(height: 2.h),
    
          _SettingsCard(children: [
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
          ]),
    
          SizedBox(height: 2.h),
    
          _SettingsCard(children: [
            _SettingsTile(
              icon: Icons.logout_rounded,
              iconBg: const Color(0xffFFE6E6),
              iconColor: const Color(0xffFF4D4D),
              title: 'Log Out',
              titleColor: const Color(0xffFF4D4D),
              arrowColor: const Color(0xffFF4D4D),
              onTap: () {
                ref.read(authProvider.notifier).signOut();
                nav.goToOnboarding();
              },
              showDivider: false,
            ),
          ]),
        ],
      ),
    );
  
  }
}

// ─── Authenticated view ───────────────────────────────────────────────────────

// ─── Unauthenticated / sign-in view ──────────────────────────────────────────



// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const CircleIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xffF1F1E6),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: const Color(0xff111111)),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(children: children),
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
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, size: 18, color: iconColor),
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

