import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/routing/router.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeMotionApp extends StatefulWidget {
  const WeMotionApp({super.key});

  @override
  State<WeMotionApp> createState() => _WeMotionAppState();
}

class _WeMotionAppState extends State<WeMotionApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'WeMotion',
          theme: ThemeData.dark().copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
            appBarTheme: const AppBarTheme(
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent),
          ),
          routerConfig: router,
        );
      },
    );
  }
}
