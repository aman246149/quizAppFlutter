import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        primaryColor: AppColor.primaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        primaryColor: AppColor.primaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      );
}
