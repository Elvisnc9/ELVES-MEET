import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluse_flutter/core/theme/app_colors.dart';
import 'package:pluse_flutter/core/theme/app_theme.dart';
import 'package:pluse_flutter/providers/navigation_controller.dart';
import 'package:pluse_flutter/screens/homeScreen.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';


class DrawerLayer extends ConsumerWidget {
  const DrawerLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(drawerOpenProvider);

    void close() => ref.read(drawerOpenProvider.notifier).state = false;

    return Stack(
      children: [
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: close,
              child: ColoredBox(
                color: Colors.black.withOpacity(0.45),
              ),
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          top: 0,
          bottom: 0,
          left: isOpen ? 0 : -82.w,
          width: 82.w,
          child: MeetDrawer(
            onClose: close,
            onSettingsTap: () {
              close();
              ref.read(navigationProvider).goToProfile();
            },
          ),
        ),
      ],
    );
  }
}


class MeetDrawer extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSettingsTap;

  const MeetDrawer({
    super.key,
    required this.onClose,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.5.h),
            Center(
              child: Text(
                'ELVES MEET',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 1.4.h),
            Divider(
              height: 1,
              thickness: 0.6,
              color: MeetColors.mid.withOpacity(0.18),
            ),
            SizedBox(height: 1.4.h),
            _DrawerItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy in Meet',
              onTap: () {},
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: onSettingsTap,
            ),
            _DrawerItem(
              icon: Icons.help_outline_rounded,
              title: 'Help & feedback',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 21, color: MeetColors.dark.withOpacity(0.9)),
            const SizedBox(width: 18),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: MeetColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}