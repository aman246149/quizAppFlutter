import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../view/quiz/quiz_screen.dart';
import '../../view/splash/splash_screen.dart';
import '../../view/onboarding/onboarding.dart';
import '../../view/quiz/quiz_result_screen.dart';
import 'rocket_page_route.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/quiz-result',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          child: QuizResultScreen(
            score: extra['score'] as int,
            total: extra['total'] as int,
            questionResults: extra['results'] as List<QuestionResult>,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return RocketPageRoute(child: child).buildTransitions(
                context, animation, secondaryAnimation, child);
          },
          transitionDuration: const Duration(milliseconds: 2000),
        );
      },
    ),
  ],
);
