import 'package:safeandromeda/core/hooks/hooks.dart';

/// Eight light rays shooting out from the Big Bang core, slowly rotating.
///
/// Energy streaks for the Big Bang era. Length grows with [progress]; the whole
/// fan turns and twinkles off [time], and the rays fade out as the era advances.
class RadialStreakPainter extends CustomPainter {
  const RadialStreakPainter({required this.progress, required this.time});

  /// Big Bang era scroll progress, 0..1.
  final double progress;

  /// Global animation clock in seconds; drives rotation and twinkle.
  final double time;

  /// Draws the rotating fan of radial energy streaks.
  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.05) return; // hold off until the blast is underway
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final Paint paint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      // Evenly spaced spokes, the whole fan slowly rotating with time.
      final double angle = (i / 8) * pi * 2 + time * 0.1;
      final double length =
          progress * size.width * 0.4; // outer end, up to 40% width
      final double startDist = progress * 20; // inner gap opens as era advances

      // Base alpha fades to 0 by end of era; per-ray sine adds a twinkle.
      final double alpha =
          ((0.3 - progress * 0.3) * (0.7 + 0.3 * sin(time + i.toDouble())))
              .clamp(0.0, 0.3);
      paint.color = AppColors.bigBangMid.withValues(alpha: alpha);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawLine(
        Offset(
          center.dx + cos(angle) * startDist,
          center.dy + sin(angle) * startDist,
        ),
        Offset(
          center.dx + cos(angle) * length,
          center.dy + sin(angle) * length,
        ),
        paint,
      );
    }
  }

  /// Repaints on scroll or clock tick (rays rotate and twinkle off time).
  @override
  bool shouldRepaint(covariant RadialStreakPainter old) =>
      old.progress != progress || old.time != time;
}
