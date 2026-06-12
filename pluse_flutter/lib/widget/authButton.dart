import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? imageIcon;
  final Color color;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isloading;

   const AuthButton( {super.key, 
    required this.text,
    required this.color,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
    required this.isloading,
    this.icon,
    this.imageIcon, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: isloading ? null : onTap, 
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
                    ? Image.asset(imageIcon!, width: 25, height: 25)
                    : Icon(icon, size: 30, color: iconColor),
              ),

              if (isloading)
                Positioned(
                  right: 25,
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                    ),
                  ),
                ),

              Text(
                isloading ? 'Signing in...' : text,
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