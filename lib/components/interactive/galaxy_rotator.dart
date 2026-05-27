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
                rotation: pro.rotation + eraProgress * pi * 2,
                progress: eraProgress,
              ),
            ),
          ),
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

    for (int arm = 0; arm < 3; arm++) {
      final double armOffset = arm * (pi * 2 / 3);

      for (int i = 0; i < 90; i++) {
        final double t = i / 90.0;
        final double spiralRadius = t * size.width * 0.3;
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

        final double dotSize = (1.0 + random.nextDouble() * 2.0) * (1.0 - t * 0.5);
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }

    // Enhanced center glow
    paint.color = AppColors.white.withValues(alpha: 0.5 * progress);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, 25, paint);
    paint.maskFilter = null;

    paint.color = AppColors.galaxiesCore.withValues(alpha: 0.3 * progress);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(center, 50, paint);
    paint.maskFilter = null;

    // Core dot
    paint.color = AppColors.white.withValues(alpha: 0.8 * progress);
    canvas.drawCircle(center, 4, paint);
    paint.color = AppColors.galaxiesCore.withValues(alpha: 0.3 * progress);
    canvas.drawCircle(center, 12, paint);
  }

  @override
  bool shouldRepaint(covariant _GalaxySpiralPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.progress != progress;
}
