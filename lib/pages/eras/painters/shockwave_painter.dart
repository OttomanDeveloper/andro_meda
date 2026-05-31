import 'package:safeandromeda/core/hooks/hooks.dart';

/// The Big Bang's initial blast: three blurred rings burst outward once and fade.
///
/// Scroll-driven (gated on [progress]), so it fires only at the start of the
/// era and is gone by mid-scroll. Distinct from ExpandingRingsPainter, which
/// loops forever off [time].
class ShockwavePainter extends CustomPainter {
  const ShockwavePainter({required this.progress, required this.time});

  /// Big Bang era scroll progress, 0..1.
  final double progress;

  /// Global animation clock in seconds (unused here; rings ride scroll).
  final double time;

  /// Draws the one-shot shockwave rings for the early part of the era.
  @override
  void paint(Canvas canvas, Size size) {
    // Only active in the opening of the era; fully gone by half-scroll.
    if (progress < 0.02 || progress > 0.5) return;
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final double ringDelay = i * 0.06; // stagger so rings fan out in sequence
      // Per-ring 0..1 life, spread across 0.3 of scroll after its delay.
      final double ringProgress = ((progress - 0.02 - ringDelay) / 0.3).clamp(
        0.0,
        1.0,
      );
      if (ringProgress <= 0) continue;

      final double radius =
          ringProgress * size.width * 0.7; // grows to 70% width
      final double opacity = ((1.0 - ringProgress) * 0.6).clamp(
        0.0,
        0.6,
      ); // fade as it expands

      paint.color = AppColors.bigBangMid.withValues(alpha: opacity);
      // Blur thickens as the ring widens, so it dissolves rather than thins.
      paint.maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        3 + ringProgress * 10,
      );
      canvas.drawCircle(center, radius, paint);
    }
  }

  /// Repaints on scroll only; rings do not animate off the clock.
  @override
  bool shouldRepaint(covariant ShockwavePainter old) =>
      old.progress != progress;
}
