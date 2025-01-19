import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_animate/flutter_animate.dart';

class RocketProgressBar extends StatelessWidget {
  final double progress;
  final bool showPercentage;

  const RocketProgressBar({
    Key? key,
    required this.progress,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Stars background
          Positioned.fill(
            child: StarsBackground(),
          ),
          Column(
            children: [
              const SizedBox(height: 8),
              // Progress bar section
              SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    // Track
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 20, // Center vertically
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Progress
                    Positioned(
                      left: 0,
                      top: 20, // Center vertically
                      child: SizedBox(
                        width: (screenWidth - 32) *
                            progress, // Account for padding
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                                theme.colorScheme.tertiary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(
                                  reverse: true), // Loop animation
                            )
                            .shimmer(duration: 1500.ms),
                      ),
                    ),
                    // Percentage
                    // if (showPercentage)
                    //   Positioned(
                    //     right: 0,
                    //     top: 0,
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 12,
                    //         vertical: 6,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: theme.colorScheme.primaryContainer,
                    //         borderRadius: BorderRadius.circular(16),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: theme.shadowColor.withOpacity(0.2),
                    //             blurRadius: 8,
                    //             offset: const Offset(0, 2),
                    //           ),
                    //         ],
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Icon(
                    //             Icons.speed_rounded,
                    //             size: 16,
                    //             color: theme.colorScheme.primary,
                    //           ),
                    //           const SizedBox(width: 4),
                    //           Text(
                    //             '${(progress * 100).toInt()}%',
                    //             style: theme.textTheme.bodySmall?.copyWith(
                    //               color: theme.colorScheme.onPrimaryContainer,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
              // Rocket section
              SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    Positioned(
                      left: (screenWidth - 64) * progress,
                      top: 0,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 4000),
                        curve: Curves.easeInOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset:
                                Offset(0, math.sin(value * 4 * math.pi) * 2),
                            child: _RocketIcon(progress: value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RocketIcon extends StatefulWidget {
  final double progress;

  const _RocketIcon({required this.progress});

  @override
  State<_RocketIcon> createState() => _RocketIconState();
}

class _RocketIconState extends State<_RocketIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _fireController;

  @override
  void initState() {
    super.initState();
    _fireController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Transform.rotate(
      angle: math.pi / 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rocket
          Transform.scale(
            scaleX: -1,
            child: Icon(
              Icons.rocket_rounded,
              color: theme.colorScheme.primary,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

class StarsBackground extends StatefulWidget {
  @override
  _StarsBackgroundState createState() => _StarsBackgroundState();
}

class _StarsBackgroundState extends State<StarsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarsPainter(progress: _controller.value),
        );
      },
    );
  }
}

class _StarsPainter extends CustomPainter {
  final double progress;

  _StarsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);

    for (var i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      // Move stars vertically based on the progress
      final y = (random.nextDouble() * size.height + progress * size.height) %
          size.height;
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
