import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/common_widgets/app_btn.dart';
import 'package:user_app/core/utils/vspace.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              'https://img.freepik.com/free-vector/quiz-background-with-items-flat-design_23-2147599082.jpg',
              fit: BoxFit.cover,
            )
                .animate(
                  delay: Duration(milliseconds: 800),
                  autoPlay: true,
                  onPlay: (controller) =>
                      controller.repeat(), // Repeat the animation
                )
                .then()
                .shimmer(duration: Duration(seconds: 2)),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                color: Color(0xFF191919),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Test Your Knowledge!",
                    style: textTheme.titleMedium
                        ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const Vspace(16),
                  Text(
                    "Challenge yourself with our interactive quizzes. Learn, compete, and track your progress as you master new topics.",
                    style: textTheme.bodyMedium
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const Vspace(16),
                  AppPrimaryButton(
                    horizontalMargin: 0,
                    verticalMargin: 0,
                    onPressed: () => context.go('/quiz'),
                    text: "Start Quiz Now",
                  ),
                  const Vspace(16),
                  AppOutLineButton(
                    onPressed: () => context.go('/quiz'),
                    text: "Practice Mode",
                  ),
                  const Vspace(15)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
