import 'package:safeandromeda/core/hooks/hooks.dart';

/// Population III supernovae, the first massive stars die young and explode,
/// forging and scattering the universe's first heavy elements.
///
/// Each site detonates on its own slow, staggered cycle: a blinding core flash,
/// an expanding shockwave, and warm ejecta rays. They begin once stars have
/// formed ([progress] > 0.4) and grow more frequent toward the end.
class SupernovaePainter extends CustomPainter {
  const SupernovaePainter({required this.progress, required this.time});

  /// First Stars era scroll progress, 0..1; gates and intensifies the blasts.
  final double progress;

  /// Global animation clock in seconds; drives each site's flare cycle.
  final double time;

  /// Number of supernova sites.
  static const int _count = 6;

  /// Warm orange of the ejecta rays.
  static const Color _ejecta = Color(0xffffb070);

  /// Draws each active supernova site (flash, shockwave, ejecta) for the frame.
  @override
  void paint(Canvas canvas, Size size) {
    // 0..1 over the era's back two-thirds; supernovae start at progress 0.35.
    final double era = ((progress - 0.35) / 0.65).clamp(0.0, 1.0);
    if (era <= 0) return;
    // Brightness floor so flares read clearly even in mid-era, ramping to full.
    final double power = 0.5 + 0.5 * era;

    final Paint paint = Paint();

    for (int i = 0; i < _count; i++) {
      final Random r = Random(i + 700); // fixed seed so each site stays fixed
      final double sx =
          (0.15 + r.nextDouble() * 0.7) * size.width; // 15%..85% across
      // Sites sit in the lower half of the (2x viewport) canvas so they are on
      // screen exactly when they activate (progress > 0.4); higher up they would
      // have already scrolled past the viewport.
      final double sy = (0.42 + r.nextDouble() * 0.5) * size.height;

      final double speed = 0.06 + r.nextDouble() * 0.05; // per-site cycle rate
      final double phase =
          (time * speed + r.nextDouble()) % 1.0; // 0..1 looping clock
      if (phase > 0.36) continue; // dormant for most of the cycle
      final double f = phase / 0.36; // 0..1 across the flare
      final double intensity =
          sin(f * pi) * power; // peaks mid-flare, zero at ends
      if (intensity <= 0.02) continue;

      final double ringR =
          f * size.width * 0.10; // shockwave radius, up to 10% width

      // Expanding shockwave ring.
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.5;
      paint.color = AppColors.firstStarsBright.withValues(
        alpha: (1 - f) * 0.5 * power,
      );
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2 + f * 6);
      canvas.drawCircle(Offset(sx, sy), ringR, paint);
      paint.maskFilter = null;

      // Element ejecta, warm rays seeding the first heavy elements.
      for (int ray = 0; ray < 8; ray++) {
        final double a =
            (ray / 8) * pi * 2 + i; // 8 even spokes, offset per site
        final double inner =
            ringR * 0.3; // ray starts just inside the shockwave
        final double len =
            f * size.width * 0.06; // ray length grows with the flare
        paint.strokeWidth = 1.2;
        paint.color = _ejecta.withValues(alpha: (1 - f) * 0.45 * power);
        canvas.drawLine(
          Offset(sx + cos(a) * inner, sy + sin(a) * inner),
          Offset(sx + cos(a) * (inner + len), sy + sin(a) * (inner + len)),
          paint,
        );
      }
      paint.style = PaintingStyle.fill;

      // Blinding core flash.
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 6 + intensity * 18);
      paint.color = AppColors.firstStarsBright.withValues(
        alpha: intensity * 0.6,
      );
      canvas.drawCircle(Offset(sx, sy), 6 + intensity * 14, paint);
      // Sharp white center on top of the blurred flash.
      paint.maskFilter = null;
      paint.color = AppColors.white.withValues(alpha: intensity);
      canvas.drawCircle(Offset(sx, sy), 1.5 + intensity * 3.5, paint);
    }
  }

  /// Repaints every clock tick since flares cycle off time.
  @override
  bool shouldRepaint(covariant SupernovaePainter old) =>
      old.time != time || old.progress != progress;
}
