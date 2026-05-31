import 'package:safeandromeda/core/hooks/hooks.dart';

/// Fish swimming in the river: teardrop bodies with flicking tails, the odd one
/// near the surface leaving a faint ripple.
class FishPainter extends CustomPainter {
  const FishPainter({
    required this.progress,
    required this.time,
    required this.count,
  });

  final double progress; // era scroll progress 0..1
  final double time; // global animation clock, seconds
  final int count; // number of fish to draw

  static const Color _fish = Color(0xff8fb4b4); // muted teal fish body

  /// Swims [count] fish back and forth within the river band, each with a
  /// flicking tail and an optional surface ripple if near the top.
  @override
  void paint(Canvas canvas, Size size) {
    // Ramp 0..1 over progress 0.2..0.45; fish appear once the river is in.
    final double appear = ((progress - 0.2) / 0.25).clamp(0.0, 1.0);
    if (appear <= 0) return;

    final double w = size.width;
    final double top = size.height * 0.81; // top of the swim band
    final double bottom = size.height * 0.99; // bottom of the swim band

    for (int i = 0; i < count; i++) {
      final Random r = Random(i + 50); // per-fish stable depth/speed/scale
      final double dir = i.isEven ? 1.0 : -1.0; // alternate swim direction
      final double speed = 0.02 + r.nextDouble() * 0.035;
      final double t =
          (time * speed + r.nextDouble()) % 1.2 - 0.1; // wrap across width
      final double x =
          (dir > 0 ? t : 1.0 - t) * w; // flip path for left-swimmers
      final double y =
          top +
          r.nextDouble() * (bottom - top) +
          sin(time * 0.8 + i) * 5; // depth + 5px bob
      final double sc = 0.7 + r.nextDouble() * 0.8; // body scale
      final double wiggle = sin(time * 6 + i * 1.3); // fast tail flick
      final double a = ((0.35 + 0.2 * sin(time + i)) * appear).clamp(
        0.0,
        0.5,
      ); // pulsing alpha

      canvas.save();
      canvas.translate(x, y);
      canvas.scale(dir, 1.0); // mirror body to face swim direction
      final Paint p = Paint()..color = _fish.withValues(alpha: a);
      // Teardrop body to a forked tail; tail tips track [wiggle] for the flick.
      canvas.drawPath(
        Path()
          ..moveTo(9 * sc, 0)
          ..quadraticBezierTo(2 * sc, -5 * sc, -9 * sc, -2.5 * sc)
          ..lineTo(-17 * sc, -5 * sc - wiggle * 3 * sc)
          ..lineTo(-13 * sc, 0)
          ..lineTo(-17 * sc, 5 * sc - wiggle * 3 * sc)
          ..lineTo(-9 * sc, 2.5 * sc)
          ..quadraticBezierTo(2 * sc, 5 * sc, 9 * sc, 0)
          ..close(),
        p,
      );
      // Dorsal fin.
      canvas.drawPath(
        Path()
          ..moveTo(-1 * sc, -3 * sc)
          ..lineTo(-4 * sc, -8 * sc)
          ..lineTo(-7 * sc, -3 * sc)
          ..close(),
        p,
      );
      canvas.restore();

      // Surface ripple for fish swimming near the top.
      if (y < top + (bottom - top) * 0.25) {
        // only the top quarter of the band
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x, top + 2),
            width: 16 * sc,
            height: 4,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = const Color(0xffaad8e0).withValues(alpha: 0.12 * appear),
        );
      }
    }
  }

  /// Repaint whenever scroll or the animation clock moves.
  @override
  bool shouldRepaint(covariant FishPainter old) =>
      old.time != time || old.progress != progress;
}
