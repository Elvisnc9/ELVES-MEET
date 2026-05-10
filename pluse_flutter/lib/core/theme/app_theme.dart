import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class AppTheme {
  static final Theme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
     progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.black,
      strokeWidth: 5
     ),
    hintColor: Colors.black,
    dividerColor: Colors.black,
    cardColor: Colors.black.withOpacity(0.9),
    canvasColor: Colors.grey.withOpacity(0.1),
    shadowColor: Colors.black,
     splashColor: Colors.black,
     focusColor: Colors.grey,
      secondaryHeaderColor: Colors.black,
      buttonTheme: ButtonThemeData(),
      iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.black),
        iconSize: WidgetStatePropertyAll(30)
      )
    ),
     textTheme: TextTheme(
    displayLarge: GoogleFonts.spaceGrotesk(
      fontSize: 24.sp,
      height: 1.5,
      fontWeight: FontWeight.bold,
    ),

    
     displayMedium: GoogleFonts.spaceGrotesk(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      height: 1.4,
     color: Colors.black
    ),
    displaySmall: GoogleFonts.spaceGrotesk(
      fontSize: 17.sp,
      fontWeight: FontWeight.bold,
     color: Colors.black
    ),

    labelMedium: GoogleFonts.spaceGrotesk(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
     color: Colors.black.withOpacity(0.8)
    
    ),

     

    labelSmall: GoogleFonts.spaceGrotesk(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
     color: Colors.black
    
    ),
      labelLarge: GoogleFonts.spaceGrotesk(
      fontSize: 17.sp,
      fontWeight: FontWeight.w500,
     color: Colors.black.withOpacity(0.95)
    
    ),

 

  ),

    
  );


}



class AppColors {
  static const Color primary = Color(0xFFFEFACD);
  static const Color secondary = Color(0xFF5F4A8B);


}




    //  Color(0xFF8E2DE2),
    //           Color(0xFF4A00E0),


