import 'package:safeandromeda/core/hooks/hooks.dart';

/// Faint clumps of neutral hydrogen that gravity slowly gathers together.
///
/// [time] gives a gentle cold drift; [progress] drives the gathering, as the
/// era advances the clumps tighten and brighten, and a few dense nodes begin to
/// ignite near the end (the first light, bridging into the First Stars era).
/// Deliberately slow and dim to match the silence of the dark ages.
class DensitySeedsPainter extends CustomPainter {
  const DensitySeedsPainter({
    required this.progress,
    required this.time,
    required this.count,
  });

  /// Cosmic Dark Ages era scroll progress, 0..1.
  final double progress;

  /// Global animation clock in seconds; gives the slow cold drift.
  final double time;

  /// Number of hydrogen clumps to draw.
  final int count;

  /// Draws the clump field plus the late-era ignition points.
  @override
  void paint(Canvas canvas, Size size) {
    // Matter only begins to gather once recombination has settled in.
    final double gather = ((progress - 0.1) / 0.9).clamp(0.0, 1.0);
    if (gather <= 0) return;

    final Paint paint = Paint();

    for (int i = 0; i < count; i++) {
      final Random r = Random(i + 4000); // fixed seed so each clump stays put
      final double driftX =
          sin(time * 0.05 + i) *
          0.012; // slow horizontal sway, fraction of width
      final double driftY =
          cos(time * 0.04 + i * 1.3) * 0.009; // slow vertical sway
      final double cx = (r.nextDouble() + driftX) * size.width;
      final double cy =
          (0.1 + r.nextDouble() * 0.8 + driftY) *
          size.height; // kept in 10%..90% band

      // Clumps tighten (smaller) and brighten as hydrogen condenses.
      final double breathe =
          0.7 + 0.3 * sin(time * 0.3 + i); // gentle 0.7..1.0 pulse
      final double alpha = ((0.14 + 0.34 * gather) * breathe).clamp(0.0, 0.5);
      final double radius =
          size.width *
          0.026 *
          (1.0 - gather * 0.3); // ~2.6% width, tightens as it gathers

      final Color clumpColor = Color.lerp(
        AppColors.darkAgesHydrogen,
        AppColors.darkAgesWisp,
        r.nextDouble(),
      )!;

      // Soft halo of gathering gas.
      paint.color = clumpColor.withValues(alpha: alpha);
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, radius);
      canvas.drawCircle(Offset(cx, cy), radius, paint);
      paint.maskFilter = null;

      // Condensed core, a visible point of matter pulling together.
      paint.color = clumpColor.withValues(
        alpha: (alpha * 1.6).clamp(0.0, 0.75),
      );
      canvas.drawCircle(Offset(cx, cy), 1.2 + 1.8 * gather, paint);

      // Dense nodes ignite as the era closes, the first light to come.
      // Every 4th clump becomes an ignition site in the era's back half.
      if (i % 4 == 0 && progress > 0.5) {
        final double ignite = ((progress - 0.5) / 0.5).clamp(
          0.0,
          1.0,
        ); // 0..1 over second half
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 6 + ignite * 14);
        paint.color = AppColors.white.withValues(alpha: ignite * 0.7);
        canvas.drawCircle(Offset(cx, cy), 2.0 + ignite * 4.0, paint);
        paint.maskFilter = null;
        // Bright white pinpoint of first light.
        paint.color = AppColors.white.withValues(alpha: ignite);
        canvas.drawCircle(Offset(cx, cy), 1.0 + ignite * 1.5, paint);
      }
    }
  }

  /// Repaints on clock tick (drift/breathe) or scroll (gathering/ignition).
  @override
  bool shouldRepaint(covariant DensitySeedsPainter old) =>
      old.time != time || old.progress != progress;
}
