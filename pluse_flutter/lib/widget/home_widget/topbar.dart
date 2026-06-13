import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluse_flutter/core/theme/app_colors.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class TopBar extends StatelessWidget {
  final TextEditingController ctrl;
  final VoidCallback onMenuTap;
  final VoidCallback onCodeTap;
  final VoidCallback onProfileTap;

  const TopBar({
    super.key,
    required this.ctrl,
    required this.onMenuTap,
    required this.onCodeTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(
              Icons.menu_rounded,
              color: MeetColors.dark,
              size: 26,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: InkWell(
              onTap: onCodeTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter a code',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MeetColors.bg,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: MeetColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms);
  }
}