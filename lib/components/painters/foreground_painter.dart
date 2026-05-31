import 'package:safeandromeda/core/hooks/hooks.dart';

/// Soft blurred orbs drifting in the foreground, adding depth and parallax.
class ForegroundPainter extends CustomPainter {
  const ForegroundPainter({
    required this.time,
    required this.color,
    this.particleCount = 15,
    this.seed = 99,
    this.cursorX = 0.0,
    this.cursorY = 0.0,
  });

  /// Global animation clock in seconds; drives the drift.
  final double time;

  /// Orb tint.
  final Color color;

  /// Number of orbs to draw.
  final int particleCount;

  /// RNG seed; fixes orb placement so it stays stable across frames.
  final int seed;

  /// Normalized cursor X (-1..1) for horizontal parallax.
  final double cursorX;

  /// Normalized cursor Y (-1..1) for vertical parallax.
  final double cursorY;

  /// Draws each drifting, blurred orb with a pulsing opacity.
  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random(seed);
    final Paint paint = Paint();

    for (int i = 0; i < particleCount; i++) {
      final double baseX = random.nextDouble() * size.width;
      final double baseY = random.nextDouble() * size.height;
      final double particleSize = 20 + random.nextDouble() * 40; // 20..60 px
      final double driftPhase = random.nextDouble() * pi * 2; // phase offset
      final double driftSpeed =
          0.45 + random.nextDouble() * 0.75; // per-orb rate

      // Drift around the base point; cursor pushes orbs opposite the pointer.
      final double x =
          baseX + sin(time * driftSpeed + driftPhase) * 30 + cursorX * -25.0;
      final double y =
          baseY +
          cos(time * driftSpeed * 0.7 + driftPhase) * 20 +
          cursorY * -15.0;

      // Opacity breathes between ~0.07 and ~0.23, offset per orb.
      paint.color = color.withValues(
        alpha: 0.15 + 0.08 * sin(time + i.toDouble()),
      );
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, particleSize * 0.5);

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  /// Repaints only when the clock or cursor moves; placement is seed-fixed.
  @override
  bool shouldRepaint(covariant ForegroundPainter old) =>
      old.time != time || old.cursorX != cursorX || old.cursorY != cursorY;
}
