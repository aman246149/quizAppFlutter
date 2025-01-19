import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/routing/router.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppAppState();
}

class _QuizAppAppState extends State<QuizApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Quiz App',
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
