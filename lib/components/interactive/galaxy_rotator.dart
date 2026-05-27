import 'package:safeandromeda/core/hooks/hooks.dart';

class _GalaxyRotatorProvider extends ChangeNotifier {
  double _rotation = 0.0;
  double get rotation => _rotation;

  double _velocity = 0.0;
  Timer? _momentumTimer;

  void rotate(double delta) {
    _rotation += delta;
    _velocity = delta;
    notifyListeners();
  }

  void startMomentum() {
    _momentumTimer?.cancel();
    _momentumTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (_velocity.abs() < 0.0001) {
        _momentumTimer?.cancel();
        return;
      }
      _velocity *= 0.95;
      _rotation += _velocity;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _momentumTimer?.cancel();
    super.dispose();
  }
}

class GalaxyRotator extends StatelessWidget {
  const GalaxyRotator({super.key, required this.eraProgress});

  final double eraProgress;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_GalaxyRotatorProvider>(
      create: (_) => _GalaxyRotatorProvider(),
      child: _GalaxyRotatorBody(eraProgress: eraProgress),
    );
  }
}

class _GalaxyRotatorBody extends StatelessWidget {
  const _GalaxyRotatorBody({required this.eraProgress});

  final double eraProgress;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<AnimationProvider>(
      builder: (_, AnimationProvider anim, _) {
        return Consumer<_GalaxyRotatorProvider>(
          builder: (_, _GalaxyRotatorProvider pro, _) {
            return GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                pro.rotate(details.delta.dx / size.width * 2);
              },
              onPanEnd: (_) {
                pro.startMomentum();
              },
              behavior: HitTestBehavior.translucent,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _GalaxySpiralPainter(
                    rotation: pro.rotation + eraProgress * pi * 2 + anim.time * 0.3,
                    progress: eraProgress,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _GalaxySpiralPainter extends CustomPainter {
  const _GalaxySpiralPainter({
    required this.rotation,
    required this.progress,
  });

  final double rotation;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final Paint paint = Paint();
    final Random random = Random(42);

    // Dust lanes - draw darker arcs between spiral arms (behind bright dots)
    final Random dustRandom = Random(43);
    for (int arm = 0; arm < 3; arm++) {
      final double laneOffset = (arm / 3) * pi * 2 + pi / 3 + rotation;
      for (int i = 0; i < 40; i++) {
        final double t = i / 40.0;
        final double r = t * size.width * 0.38;
        final double angle = laneOffset + t * pi * 2.8;
        final double x = center.dx + r * cos(angle) + (dustRandom.nextDouble() - 0.5) * 8;
        final double y = center.dy + r * sin(angle) * 0.6 + (dustRandom.nextDouble() - 0.5) * 5;

        paint.color = AppColors.galaxiesBg.withValues(alpha: (0.3 * t * progress).clamp(0.0, 0.3));
        canvas.drawCircle(Offset(x, y), 4.5 + dustRandom.nextDouble() * 6, paint);
      }
    }

    // Bright spiral arm dots
    for (int arm = 0; arm < 3; arm++) {
      final double armOffset = arm * (pi * 2 / 3);

      for (int i = 0; i < 120; i++) {
        final double t = i / 120.0;
        final double spiralRadius = t * size.width * 0.42;
        final double angle = armOffset + rotation + t * pi * 3;

        final double jitterX = (random.nextDouble() - 0.5) * 15;
        final double jitterY = (random.nextDouble() - 0.5) * 15;

        final double x = center.dx + spiralRadius * cos(angle) + jitterX;
        final double y = center.dy + spiralRadius * sin(angle) * 0.6 + jitterY;

        final double starOpacity = ((1.0 - t) * 0.7 * progress).clamp(0.0, 0.7);
        paint.color = Color.lerp(
          AppColors.galaxiesCore,
          AppColors.galaxiesArm,
          t,
        )!.withValues(alpha: starOpacity);

        final double dotSize = (1.3 + random.nextDouble() * 2.6) * (1.0 - t * 0.5);
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }

    // Enhanced center glow
    paint.color = AppColors.white.withValues(alpha: 0.5 * progress);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 35);
    canvas.drawCircle(center, 35, paint);
    paint.maskFilter = null;

    paint.color = AppColors.galaxiesCore.withValues(alpha: 0.3 * progress);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 70);
    canvas.drawCircle(center, 70, paint);
    paint.maskFilter = null;

    // Galactic core rings
    for (int ring = 0; ring < 4; ring++) {
      final double ringRadius = 8.0 + ring * 6.0;
      final double ringOpacity = (0.15 - ring * 0.03) * progress;
      paint.color = AppColors.galaxiesCore.withValues(alpha: ringOpacity.clamp(0.0, 0.15));
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.5;
      canvas.drawCircle(center, ringRadius, paint);
    }
    paint.style = PaintingStyle.fill;

    // Core dot
    paint.color = AppColors.white.withValues(alpha: 0.8 * progress);
    canvas.drawCircle(center, 6, paint);
    paint.color = AppColors.galaxiesCore.withValues(alpha: 0.3 * progress);
    canvas.drawCircle(center, 18, paint);
  }

  @override
  bool shouldRepaint(covariant _GalaxySpiralPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.progress != progress;
}
