import 'package:safeandromeda/core/hooks/hooks.dart';

/// Star-formation flashes inside a galaxy: a few bursts pop on a staggered
/// cycle, each a six-ray sparkle with a center flash that expands and fades.
class StarBirthPainter extends CustomPainter {
  const StarBirthPainter({required this.progress, required this.time});

  /// Era scroll progress, 0..1. Bursts only draw past 0.2.
  final double progress;

  /// Global animation clock in seconds; drives the burst cycle.
  final double time;

  /// Places up to 5 bursts around the galaxy center, each visible for the
  /// first third of its 3s cycle.
  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.2) return;
    final Paint paint = Paint();
    final Random r = Random(33); // fixed seed so burst offsets are stable
    final Offset galaxyCenter = Offset(size.width * 0.5, size.height * 0.4);

    for (int burst = 0; burst < 5; burst++) {
      // 0..3 saw per burst, staggered by 1.7; only 0..1 is the visible flash.
      final double burstPhase = (time * 0.3 + burst * 1.7) % 3.0;
      if (burstPhase > 1.0) continue;

      final double angle = r.nextDouble() * pi * 2;
      final double dist =
          30 + r.nextDouble() * size.width * 0.2; // scatter radius
      final Offset burstCenter = Offset(
        galaxyCenter.dx + cos(angle + burst) * dist,
        galaxyCenter.dy +
            sin(angle + burst) * dist * 0.6, // 0.6 = flatten to disk
      );

      for (int ray = 0; ray < 6; ray++) {
        final double rayAngle = (ray / 6) * pi * 2; // 6 rays evenly around
        final double rayLength = burstPhase * 15; // rays grow over the flash
        final double alpha = ((1.0 - burstPhase) * 0.8 * progress).clamp(
          0.0,
          0.8,
        ); // fades as the flash ages

        paint.color = AppColors.firstStarsBright.withValues(alpha: alpha);
        paint.strokeWidth = 1;
        paint.style = PaintingStyle.stroke;
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

        canvas.drawLine(
          burstCenter,
          Offset(
            burstCenter.dx + cos(rayAngle) * rayLength,
            burstCenter.dy + sin(rayAngle) * rayLength,
          ),
          paint,
        );
      }

      // Center flash: bright blob that shrinks as the flash ages.
      paint.style = PaintingStyle.fill;
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      paint.color = AppColors.firstStarsBright.withValues(
        alpha: ((1.0 - burstPhase) * 0.9 * progress).clamp(0.0, 0.9),
      );
      canvas.drawCircle(burstCenter, 3 * (1.0 - burstPhase), paint);
      paint.maskFilter = null;
    }
  }

  /// Repaint when scroll progress or the clock changes.
  @override
  bool shouldRepaint(covariant StarBirthPainter old) =>
      old.progress != progress || old.time != time;
}
