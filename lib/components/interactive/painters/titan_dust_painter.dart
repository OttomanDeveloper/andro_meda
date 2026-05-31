import 'package:safeandromeda/core/hooks/hooks.dart';

/// Dust the three titans kick up at their feet as they lunge and fight.
class TitanDustPainter extends CustomPainter {
  const TitanDustPainter({required this.time});

  final double time; // global animation clock, seconds

  static const Color _dust = Color(0xff6b5e3e); // muted brown dust kicked up
  // Foot positions of the three titans, as fractions of the era canvas.
  static const List<Offset> _feet = [
    Offset(0.16, 0.50),
    Offset(0.48, 0.50),
    Offset(0.80, 0.45),
  ];

  /// Emits 7 looping dust puffs per foot that rise, spread, and fade.
  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint();
    for (int f = 0; f < _feet.length; f++) {
      final double fx = _feet[f].dx * size.width;
      final double fy = _feet[f].dy * size.height;
      final Random r = Random(f * 13 + 5); // per-foot seed, stable puff offsets
      for (int i = 0; i < 7; i++) {
        // Each puff cycles 0..1 at its own rate; i*0.6 staggers them.
        final double phase =
            (time * (0.8 + r.nextDouble() * 0.6) + i * 0.6) % 1.0;
        final double a = (1 - phase) * 0.2; // fade out, max alpha 0.2 at birth
        if (a <= 0.01) continue; // skip near-invisible puffs
        // Horizontal drift widens as the puff ages (+/- up to ~35px).
        final double spread = (r.nextDouble() - 0.5) * 50 * (0.4 + phase);
        p.color = _dust.withValues(alpha: a);
        p.maskFilter = MaskFilter.blur(BlurStyle.normal, 3 + phase * 4);
        canvas.drawCircle(
          Offset(fx + spread, fy - phase * 24), // rises up to 24px as it ages
          5 + phase * 9, // grows from 5px to 14px radius
          p,
        );
      }
    }
    p.maskFilter = null;
  }

  /// Repaints every clock tick to advance the dust animation.
  @override
  bool shouldRepaint(covariant TitanDustPainter old) => old.time != time;
}
