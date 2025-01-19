import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/localdb.dart';
import 'viewmodel/home_viewmodel.dart';
import 'quiz_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'viewmodel/quiz_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.toString()}');
  };

  // Initialize LocalDb
  await LocalDb().init();
  await ScreenUtil.ensureScreenSize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewmodel()),
      ],
      child: const QuizApp(),
    ),
  );
}
