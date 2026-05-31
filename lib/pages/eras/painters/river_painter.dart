import 'package:safeandromeda/core/hooks/hooks.dart';

/// A river across the foreground with a wavy surface, soft reflections, and
/// flowing ripple highlights that drift downstream.
class RiverPainter extends CustomPainter {
  const RiverPainter({required this.progress, required this.time});
  final double progress; // era scroll progress 0..1
  final double time; // global animation clock, seconds

  /// Fills the water body, lays down reflections, then the moving ripples.
  @override
  void paint(Canvas canvas, Size size) {
    // Ramp 0..1 over progress 0.18..0.43; river fades in mid-era.
    final double appear = ((progress - 0.18) / 0.25).clamp(0.0, 1.0);
    if (appear <= 0) return;

    final double w = size.width;
    final double top = size.height * 0.80; // water starts at 80% height
    final double bottom = size.height; // down to the canvas foot

    // Wavy top edge sampled every 24px; sine scrolls right over time.
    final Path surface = Path()..moveTo(0, top);
    for (double x = 0; x <= w; x += 24) {
      surface.lineTo(
        x,
        top + sin(x * 0.012 + time * 1.4) * 4,
      ); // 4px wave amplitude
    }
    surface
      ..lineTo(w, bottom)
      ..lineTo(0, bottom)
      ..close();

    final Paint water = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff2c5560).withValues(alpha: 0.78 * appear),
          const Color(0xff10242a).withValues(alpha: 0.92 * appear),
        ],
      ).createShader(Rect.fromLTWH(0, top, w, bottom - top));
    canvas.drawPath(surface, water);

    // Soft dark reflections wobbling on the surface.
    final Random rr = Random(21); // fixed seed: reflection columns are stable
    final Paint refl = Paint()
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        3,
      ); // blur softens edges
    for (int i = 0; i < 10; i++) {
      final double rx =
          rr.nextDouble() * w +
          sin(time * 1.1 + i) * 3; // 3px horizontal wobble
      refl.color = const Color(0xff0a1508).withValues(alpha: 0.16 * appear);
      canvas.drawRect(
        Rect.fromLTWH(rx, top, 6 + rr.nextDouble() * 8, (bottom - top) * 0.5),
        refl,
      );
    }

    // Flowing ripple highlights drifting across the current.
    final Paint ripple = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 24; i++) {
      final Random r = Random(i + 7); // per-ripple stable depth/length/start
      final double baseY =
          top + 6 + r.nextDouble() * (bottom - top - 10); // depth in the water
      final double speed =
          0.05 + r.nextDouble() * 0.06; // downstream drift rate
      final double flow =
          (time * speed + r.nextDouble()) % 1.2 - 0.1; // wrap across width
      final double rx = flow * w;
      final double rlen = 20 + r.nextDouble() * 34; // ripple stroke length
      final double shimmer =
          0.45 + 0.55 * sin(time * 2 + i); // pulsing brightness 0..1
      ripple.color = const Color(
        0xff8fd8e4,
      ).withValues(alpha: (0.3 * shimmer * appear).clamp(0.0, 0.4));
      canvas.drawPath(
        Path()
          ..moveTo(rx, baseY)
          ..relativeQuadraticBezierTo(rlen * 0.5, -2.5, rlen, 0),
        ripple,
      );
    }
  }

  /// Repaint whenever scroll or the animation clock moves.
  @override
  bool shouldRepaint(covariant RiverPainter old) =>
      old.time != time || old.progress != progress;
}
