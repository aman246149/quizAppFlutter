import 'package:flutter/material.dart';
import 'dart:math' as math;

class RocketCompletionAnimation extends StatefulWidget {
  final VoidCallback onComplete;

  const RocketCompletionAnimation({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<RocketCompletionAnimation> createState() =>
      _RocketCompletionAnimationState();
}

class _RocketCompletionAnimationState extends State<RocketCompletionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _flyAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.4, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOutCubic),
      ),
    );

    _flyAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.easeInExpo),
      ),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Particle effects
            ..._buildParticles(theme),
            // Rocket
            Transform.translate(
              offset: Offset(
                0,
                -MediaQuery.of(context).size.height * _flyAnimation.value,
              ),
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Flame trail
                      Positioned(
                        bottom: -10,
                        child: Icon(
                          Icons.local_fire_department_rounded,
                          color: theme.colorScheme.error,
                          size: 48,
                        ),
                      ),
                      Icon(
                        Icons.rocket_rounded,
                        color: theme.colorScheme.primary,
                        size: 64,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildParticles(ThemeData theme) {
    final random = math.Random(42);
    return List.generate(20, (index) {
      final delay = random.nextDouble() * 0.5;
      final speed = 0.3 + random.nextDouble() * 0.7;
      final size = 4.0 + random.nextDouble() * 4;

      return Positioned(
        left: random.nextDouble() * 200 - 100,
        child: Transform.translate(
          offset: Offset(
            0,
            200 * (1 - _flyAnimation.value * speed - delay),
          ),
          child: Opacity(
            opacity: (1 - _flyAnimation.value).clamp(0, 1),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    });
  }
}
