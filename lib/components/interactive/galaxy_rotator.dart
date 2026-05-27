import 'package:safeandromeda/core/hooks/hooks.dart';

class _GalaxyRotatorProvider extends ChangeNotifier {
  double _rotation = 0.0;
  double get rotation => _rotation;

  void rotate(double delta) {
    _rotation += delta;
    notifyListeners();
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

      for (int i = 0; i < 60; i++) {
        final double t = i / 60.0;
        final double spiralRadius = t * size.width * 0.2;
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

    paint.color = AppColors.white.withValues(alpha: 0.8 * progress);
    canvas.drawCircle(center, 4, paint);
    paint.color = AppColors.galaxiesCore.withValues(alpha: 0.3 * progress);
    canvas.drawCircle(center, 12, paint);
  }

  @override
  bool shouldRepaint(covariant _GalaxySpiralPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.progress != progress;
}
