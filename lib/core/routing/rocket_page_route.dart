import 'package:flutter/material.dart';
import 'dart:math' as math;

class RocketPageRoute extends PageRouteBuilder {
  final Widget child;

  RocketPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 2000),
          reverseTransitionDuration: const Duration(milliseconds: 1500),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Stack(
      children: [
        // Slide and fade the new page from bottom
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          )),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: child,
          ),
        ),
        // Rocket animation
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final rocketProgress = animation.value;
            final screenHeight = MediaQuery.of(context).size.height;
            final screenWidth = MediaQuery.of(context).size.width;

            // Calculate rocket path using quadratic bezier curve
            final startPoint = Offset(screenWidth * 0.5, screenHeight * 1.1);
            final controlPoint = Offset(screenWidth * 0.2, screenHeight * 0.5);
            final endPoint = Offset(screenWidth * 0.8, -screenHeight * 0.1);

            final currentPoint = _evaluateBezier(
              startPoint,
              controlPoint,
              endPoint,
              rocketProgress,
            );

            // Calculate rotation based on path tangent
            final rotation = _calculateRotation(
              rocketProgress,
              startPoint,
              controlPoint,
              endPoint,
            );

            final scale = 1.0 - rocketProgress * 0.3;

            return Positioned(
              left: currentPoint.dx - 32,
              top: currentPoint.dy - 32,
              child: Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Flame trail
                      Positioned(
                        top: -10,
                        child: Icon(
                          Icons.local_fire_department_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 48,
                        ),
                      ),
                      Icon(
                        Icons.rocket_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 64,
                      ),
                      // Particle effects
                      if (rocketProgress < 0.8) ..._buildParticles(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Offset _evaluateBezier(
    Offset p0,
    Offset p1,
    Offset p2,
    double t,
  ) {
    final u = 1 - t;
    final tt = t * t;
    final uu = u * u;

    return Offset(
      uu * p0.dx + 2 * u * t * p1.dx + tt * p2.dx,
      uu * p0.dy + 2 * u * t * p1.dy + tt * p2.dy,
    );
  }

  double _calculateRotation(
    double t,
    Offset p0,
    Offset p1,
    Offset p2,
  ) {
    // Calculate tangent vector
    final u = 1 - t;
    final dx = 2 * (p1.dx - p0.dx) * u + 2 * (p2.dx - p1.dx) * t;
    final dy = 2 * (p1.dy - p0.dy) * u + 2 * (p2.dy - p1.dy) * t;

    // Add pi/2 instead of subtracting to flip the rocket upright
    return math.atan2(dy, dx) + math.pi / 2;
  }

  List<Widget> _buildParticles(BuildContext context) {
    final random = math.Random(42);
    return List.generate(15, (index) {
      final size = 3.0 + random.nextDouble() * 3;
      final xOffset = (random.nextDouble() - 0.5) * 60;
      final yOffset = 20 + random.nextDouble() * 40;

      return Positioned(
        left: xOffset,
        bottom: -yOffset,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      );
    });
  }
}
