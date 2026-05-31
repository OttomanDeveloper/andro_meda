import 'package:safeandromeda/core/hooks/hooks.dart';

/// Concentric energy rings that perpetually emanate from the singularity.
///
/// Driven purely by [time] (not scroll), so the universe reads as *constantly*
/// expanding even before the user scrolls. Each ring grows outward and recycles
/// on a staggered phase, fading as it dissolves into the void.
class ExpandingRingsPainter extends CustomPainter {
  const ExpandingRingsPainter({required this.progress, required this.time});

  /// Big Bang era scroll progress, 0..1.
  final double progress;

  /// Global animation clock in seconds; sole driver of the ring loop.
  final double time;

  /// Number of rings in flight at once, evenly offset in phase.
  static const int _ringCount = 6;

  /// Draws the looping ring field once per frame.
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final double maxRadius = size.width * 0.9; // ring radius at end of its life
    // Alive from the very start; intensifies a touch as the explosion unfolds.
    final double visibility = (0.5 + progress * 0.5).clamp(0.0, 1.0);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (int i = 0; i < _ringCount; i++) {
      // 0..1 life cycle, staggered per ring; 0.18 sets the loop speed.
      final double phase = (time * 0.18 + i / _ringCount) % 1.0;
      final double radius = phase * maxRadius;
      // Brightest mid-flight, vanishing at the core and at the rim.
      final double fade = sin(phase * pi) * 0.22 * visibility;
      if (fade <= 0.003) continue;

      paint.color = Color.lerp(
        AppColors.bigBangCenter,
        AppColors.bigBangOuter,
        phase,
      )!.withValues(alpha: fade);
      // Softer blur as the ring grows, so it melts into the void at the rim.
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2 + phase * 6);
      canvas.drawCircle(center, radius, paint);
    }
  }

  /// Repaints every clock tick since the rings loop off time.
  @override
  bool shouldRepaint(covariant ExpandingRingsPainter old) =>
      old.time != time || old.progress != progress;
}
