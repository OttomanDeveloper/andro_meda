import 'package:safeandromeda/core/hooks/hooks.dart';

class ForegroundPainter extends CustomPainter {
  const ForegroundPainter({
    required this.time,
    required this.color,
    this.particleCount = 15,
    this.seed = 99,
    this.cursorX = 0.0,
    this.cursorY = 0.0,
  });

  final double time;
  final Color color;
  final int particleCount;
  final int seed;
  final double cursorX;
  final double cursorY;

  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(seed);
    final Paint paint = Paint();

    for (int i = 0; i < particleCount; i++) {
      final double baseX = random.nextDouble() * size.width;
      final double baseY = random.nextDouble() * size.height;
      final double particleSize = 20 + random.nextDouble() * 40;
      final double driftPhase = random.nextDouble() * pi * 2;
      final double driftSpeed = 0.45 + random.nextDouble() * 0.75;

      final double x = baseX +
          sin(time * driftSpeed + driftPhase) * 30 +
          cursorX * -25.0;
      final double y = baseY +
          cos(time * driftSpeed * 0.7 + driftPhase) * 20 +
          cursorY * -15.0;

      paint.color =
          color.withValues(alpha: 0.15 + 0.08 * sin(time + i.toDouble()));
      paint.maskFilter =
          MaskFilter.blur(BlurStyle.normal, particleSize * 0.5);

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ForegroundPainter old) =>
      old.time != time || old.cursorX != cursorX || old.cursorY != cursorY;
}
