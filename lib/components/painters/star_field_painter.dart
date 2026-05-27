import 'package:safeandromeda/core/hooks/hooks.dart';

class StarFieldPainter extends CustomPainter {
  const StarFieldPainter({
    required this.progress,
    this.starCount = 120,
    this.baseColor = AppColors.white,
    this.seed = 42,
    this.maxOpacity = 1.0,
  });

  final double progress;
  final int starCount;
  final Color baseColor;
  final int seed;
  final double maxOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(seed);
    final Paint paint = Paint();

    for (int i = 0; i < starCount; i++) {
      final double x = random.nextDouble() * size.width;
      final double baseY = random.nextDouble() * size.height;
      final double starSize = random.nextDouble() * 2.0 + 0.5;
      final double depth = random.nextDouble();

      final double parallax = progress * size.height * 0.1 * depth;
      final double y = baseY - parallax;

      if (y < -10 || y > size.height + 10) continue;

      final double twinkle =
          (0.5 + 0.5 * ((i * 0.7 + progress * 3.0) % 1.0)).clamp(0.3, 1.0);
      final double opacity = (twinkle * maxOpacity).clamp(0.0, 1.0);

      paint.color = baseColor.withValues(alpha: opacity);

      canvas.drawCircle(Offset(x, y), starSize, paint);

      if (starSize > 1.5) {
        paint.color = baseColor.withValues(alpha: opacity * 0.3);
        canvas.drawCircle(Offset(x, y), starSize * 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
