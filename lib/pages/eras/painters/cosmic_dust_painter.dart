import 'package:safeandromeda/core/hooks/hooks.dart';

/// A field of primordial matter streaming continuously outward from the centre.
///
/// Every mote travels along a fixed seeded ray and recycles back to the core,
/// so there is always matter in flight, reinforcing the sense of relentless
/// expansion. Each mote carries a soft glow and a bright white core.
class CosmicDustPainter extends CustomPainter {
  const CosmicDustPainter({
    required this.progress,
    required this.time,
    required this.count,
  });

  /// Big Bang era scroll progress, 0..1.
  final double progress;

  /// Global animation clock in seconds; drives each mote's outward travel.
  final double time;

  /// Number of dust motes to draw.
  final int count;

  /// Draws every mote at its current point along its seeded outbound ray.
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final double maxDist = size.width * 0.75; // farthest a mote travels
    // Overall opacity: dim floor, brighter as the explosion unfolds.
    final double field = (0.4 + progress * 0.6).clamp(0.0, 1.0);
    final Paint paint = Paint();

    for (int i = 0; i < count; i++) {
      final Random r = Random(i + 9000); // fixed seed so each mote is stable
      final double angle = r.nextDouble() * pi * 2; // direction of its ray
      final double speed = 0.05 + r.nextDouble() * 0.12; // per-mote travel rate
      final double phase =
          (time * speed + r.nextDouble()) % 1.0; // 0..1 along ray, recycles
      final double dist =
          phase *
          maxDist *
          (0.4 + r.nextDouble() * 0.6); // current distance from core

      // Brightest mid-flight (sin peak), invisible at core and far edge.
      final double alpha = (sin(phase * pi) * 0.5 * field).clamp(0.0, 0.5);
      if (alpha <= 0.01) continue;

      final double dx = center.dx + cos(angle) * dist;
      final double dy = center.dy + sin(angle) * dist;
      // Shrinks as it travels out, so motes feel like they recede.
      final double moteSize =
          (0.6 + r.nextDouble() * 1.8) * (1.0 - phase * 0.5);

      paint.color = Color.lerp(
        AppColors.bigBangCenter,
        AppColors.bigBangMid,
        r.nextDouble(),
      )!.withValues(alpha: alpha);
      // Soft outer glow (1.8x radius).
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(dx, dy), moteSize * 1.8, paint);

      // Sharp white core (0.5x radius) for a sparkle inside the glow.
      paint.maskFilter = null;
      paint.color = AppColors.white.withValues(alpha: alpha * 0.8);
      canvas.drawCircle(Offset(dx, dy), moteSize * 0.5, paint);
    }
  }

  /// Repaints every clock tick since motes travel off time.
  @override
  bool shouldRepaint(covariant CosmicDustPainter old) =>
      old.time != time || old.progress != progress;
}
