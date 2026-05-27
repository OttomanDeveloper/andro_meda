import 'package:safeandromeda/core/hooks/hooks.dart';

class StarFieldPainter extends CustomPainter {
  const StarFieldPainter({
    required this.progress,
    required this.time,
    this.starCount = 120,
    this.baseColor = AppColors.white,
    this.seed = 42,
    this.maxOpacity = 1.0,
    this.cursorX = 0.0,
    this.cursorY = 0.0,
  });

  final double progress;
  final double time;
  final int starCount;
  final Color baseColor;
  final int seed;
  final double maxOpacity;
  final double cursorX;
  final double cursorY;

  /// Star color temperature: warm white, cool blue, or pale yellow based on index seed.
  Color _starColor(int index) {
    final int variant = (index * 7 + seed) % 5;
    switch (variant) {
      case 0:
        return const Color(0xffaaccff); // cool blue
      case 1:
        return const Color(0xffffffcc); // pale yellow
      case 2:
        return const Color(0xffffddaa); // warm white
      default:
        return baseColor;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(seed);
    final Paint paint = Paint();

    for (int i = 0; i < starCount; i++) {
      final double x = random.nextDouble() * size.width;
      final double baseY = random.nextDouble() * size.height;
      final double starSize = random.nextDouble() * 2.0 + 0.5;
      final double depth = random.nextDouble();
      final double twinkleSpeed = 2.0 + random.nextDouble() * 3.0;

      final double parallax = progress * size.height * 0.1 * depth;
      final double parallaxX = cursorX * 15.0 * depth;
      final double parallaxY = cursorY * 10.0 * depth;
      final double finalX = x + parallaxX;
      final double finalY = baseY - parallax + parallaxY;

      if (finalY < -10 || finalY > size.height + 10) continue;

      // Ambient twinkle: sinusoidal opacity modulation driven by time
      final double twinkle =
          (0.5 + 0.5 * sin(time * twinkleSpeed + i * 0.7)).clamp(0.3, 1.0);
      final double opacity = (twinkle * maxOpacity).clamp(0.0, 1.0);

      final Color color = _starColor(i);

      // 1. Outer glow (6x radius, very soft)
      paint.color = color.withValues(alpha: opacity * 0.18);
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, starSize * 4);
      canvas.drawCircle(Offset(finalX, finalY), starSize * 6, paint);

      // 2. Mid glow (3x radius)
      paint.color = color.withValues(alpha: opacity * 0.4);
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, starSize * 2);
      canvas.drawCircle(Offset(finalX, finalY), starSize * 3, paint);

      // 3. Core (full opacity, no blur)
      paint.color = color.withValues(alpha: opacity);
      paint.maskFilter = null;
      if (starSize > 1.5) {
        _drawPointedStar(canvas, Offset(finalX, finalY), starSize, paint);
      } else {
        canvas.drawCircle(Offset(finalX, finalY), starSize, paint);
      }

      // 4. Cross spikes for large bright stars
      if (starSize > 1.8) {
        final double spikeLength = starSize * 5;
        paint.color = color.withValues(alpha: opacity * 0.5);
        paint.strokeWidth = 1.5;
        paint.style = PaintingStyle.stroke;
        // Horizontal spike
        canvas.drawLine(
          Offset(finalX - spikeLength, finalY),
          Offset(finalX + spikeLength, finalY),
          paint,
        );
        // Vertical spike
        canvas.drawLine(
          Offset(finalX, finalY - spikeLength),
          Offset(finalX, finalY + spikeLength),
          paint,
        );
        paint.style = PaintingStyle.fill;
      }
    }
  }

  void _drawPointedStar(Canvas canvas, Offset center, double size, Paint paint) {
    final Path path = Path();
    final double inner = size * 0.3;
    final double outer = size;

    for (int i = 0; i < 4; i++) {
      final double angle = (i / 4) * pi * 2 - pi / 2;
      final double nextAngle = ((i + 0.5) / 4) * pi * 2 - pi / 2;

      if (i == 0) {
        path.moveTo(center.dx + cos(angle) * outer, center.dy + sin(angle) * outer);
      } else {
        path.lineTo(center.dx + cos(angle) * outer, center.dy + sin(angle) * outer);
      }
      path.lineTo(center.dx + cos(nextAngle) * inner, center.dy + sin(nextAngle) * inner);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.time != time ||
      oldDelegate.cursorX != cursorX ||
      oldDelegate.cursorY != cursorY;
}
