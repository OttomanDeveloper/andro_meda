import 'package:safeandromeda/core/hooks/hooks.dart';

/// A community of early single-celled life drifting through the primordial
/// soup: round cocci, rod-shaped bacilli, flagellated swimmers, and cells
/// caught mid-division (binary fission). Each wanders with gentle organic
/// motion; flagellates wiggle their tails and dividing cells slowly pinch apart.
class MicrobesPainter extends CustomPainter {
  const MicrobesPainter({
    required this.progress,
    required this.time,
    required this.count,
  });

  /// Era scroll progress, 0..1; gates the fade-in.
  final double progress;

  /// Global animation clock in seconds; drives wander, wiggle and division.
  final double time;

  /// How many microbes to draw.
  final int count;

  /// Places each microbe by its stable seed, picks one of four types, and
  /// dispatches to the matching draw helper.
  @override
  void paint(Canvas canvas, Size size) {
    final double appear = ((progress - 0.1) / 0.25).clamp(
      0.0,
      1.0,
    ); // 0..1 fade-in
    if (appear <= 0) return;

    for (int i = 0; i < count; i++) {
      final Random r = Random(i + 600); // per-microbe stable seed
      final int type = i % 4; // 0 coccus, 1 bacillus, 2 flagellate, 3 dividing
      final double wanderS = 0.08 + r.nextDouble() * 0.14; // wander speed
      final double phase = r.nextDouble() * pi * 2; // per-microbe motion offset
      final double x =
          (0.08 + r.nextDouble() * 0.84 + sin(time * wanderS + phase) * 0.03) *
          size.width;
      final double y =
          (0.1 +
              r.nextDouble() * 0.8 +
              cos(time * wanderS * 0.8 + phase) * 0.025) *
          size.height;
      final double cellR =
          size.width *
          0.016 *
          (0.7 + r.nextDouble() * 0.8); // base radius ~1.6% width
      final Color col = Color.lerp(
        AppColors.lifeGreen,
        AppColors.lifeTeal,
        r.nextDouble(),
      )!;
      final double a =
          appear *
          (0.6 + 0.25 * sin(time * 0.5 + i)); // alpha breathes over time
      if (a <= 0.02) continue;
      final double heading = time * wanderS + phase; // facing direction
      final Offset c = Offset(x, y);

      if (type == 0) {
        _drawCoccus(canvas, c, cellR, col, a);
      } else if (type == 1) {
        _drawBacillus(canvas, c, cellR, heading, col, a);
      } else if (type == 2) {
        _drawFlagellate(canvas, c, cellR, heading, col, a, i);
      } else {
        _drawDividing(canvas, c, cellR, heading, col, a, r);
      }
    }
  }

  /// Spherical bacterium with membrane, nucleoid and a granule.
  void _drawCoccus(Canvas canvas, Offset c, double r, Color col, double a) {
    final Paint p = Paint();
    p.color = col.withValues(alpha: 0.15 * a);
    p.maskFilter = MaskFilter.blur(BlurStyle.normal, r);
    canvas.drawCircle(c, r * 1.4, p);
    p.maskFilter = null;
    p.color = col.withValues(alpha: 0.42 * a);
    canvas.drawCircle(c, r, p);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.3;
    p.color = col.withValues(alpha: 0.75 * a);
    canvas.drawCircle(c, r, p);
    p.style = PaintingStyle.fill;
    p.color = AppColors.white.withValues(alpha: 0.45 * a);
    canvas.drawCircle(c.translate(r * 0.2, -r * 0.15), r * 0.22, p);
    p.color = col.withValues(alpha: 0.7 * a);
    canvas.drawCircle(c.translate(-r * 0.3, r * 0.25), r * 0.14, p);
  }

  /// Rod-shaped bacterium (capsule) oriented along its heading.
  void _drawBacillus(
    Canvas canvas,
    Offset c,
    double r,
    double heading,
    Color col,
    double a,
  ) {
    final Paint p = Paint();
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(heading);
    final double len = r * 3.0;
    final double w = r * 1.3;
    final RRect body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: len, height: w),
      Radius.circular(w / 2),
    );
    p.color = col.withValues(alpha: 0.12 * a);
    p.maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.8);
    canvas.drawRRect(body, p);
    p.maskFilter = null;
    p.color = col.withValues(alpha: 0.42 * a);
    canvas.drawRRect(body, p);
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.0;
    p.color = col.withValues(alpha: 0.6 * a);
    canvas.drawRRect(body, p);
    p.style = PaintingStyle.fill;
    p.color = AppColors.white.withValues(alpha: 0.35 * a);
    canvas.drawCircle(Offset(-len * 0.22, 0), r * 0.2, p);
    canvas.drawCircle(Offset(len * 0.22, 0), r * 0.2, p);
    canvas.restore();
  }

  /// Oval swimmer trailing a wiggling flagellum.
  void _drawFlagellate(
    Canvas canvas,
    Offset c,
    double r,
    double heading,
    Color col,
    double a,
    int i,
  ) {
    final Paint p = Paint();
    final double dirX = cos(heading);
    final double dirY = sin(heading);
    final double perpX = -dirY;
    final double perpY = dirX;

    final Path tail = Path();
    for (int s = 0; s <= 18; s++) {
      final double t = s / 18; // 0 at body, 1 at tail tip
      final double along = -t * r * 4.5; // tail trails behind the heading
      final double wave =
          sin(t * pi * 3 - time * 6 + i) *
          r *
          0.7 *
          t; // wiggle, grows toward tip
      final double tx = c.dx + dirX * along + perpX * wave;
      final double ty = c.dy + dirY * along + perpY * wave;
      if (s == 0) {
        tail.moveTo(tx, ty);
      } else {
        tail.lineTo(tx, ty);
      }
    }
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.0;
    p.color = col.withValues(alpha: 0.5 * a);
    canvas.drawPath(tail, p);
    p.style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(heading);
    p.color = col.withValues(alpha: 0.14 * a);
    p.maskFilter = MaskFilter.blur(BlurStyle.normal, r);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r * 2.6, height: r * 1.6),
      p,
    );
    p.maskFilter = null;
    p.color = col.withValues(alpha: 0.38 * a);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: r * 2.4, height: r * 1.5),
      p,
    );
    p.color = AppColors.white.withValues(alpha: 0.45 * a);
    canvas.drawCircle(Offset(r * 0.4, 0), r * 0.3, p);
    canvas.restore();
  }

  /// Two daughter cells slowly pinching apart (binary fission).
  void _drawDividing(
    Canvas canvas,
    Offset c,
    double r,
    double heading,
    Color col,
    double a,
    Random rng,
  ) {
    final Paint p = Paint();
    final double cyc =
        (time * 0.3 + rng.nextDouble() * 6) % 4.0; // 0..4s division cycle
    final double split = (cyc / 4.0).clamp(0.0, 1.0); // 0 joined, 1 fully split
    final double sep = r * 1.25 * split; // gap between the two daughters
    final double dirX = cos(heading);
    final double dirY = sin(heading);
    final double rr =
        r * (1.0 - split * 0.12); // daughters shrink slightly as they part
    final List<Offset> centers = [
      Offset(c.dx + dirX * sep, c.dy + dirY * sep),
      Offset(c.dx - dirX * sep, c.dy - dirY * sep),
    ];
    for (final Offset cc in centers) {
      p.color = col.withValues(alpha: 0.13 * a);
      p.maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.8);
      canvas.drawCircle(cc, rr * 1.3, p);
      p.maskFilter = null;
      p.color = col.withValues(alpha: 0.42 * a);
      canvas.drawCircle(cc, rr, p);
      p.style = PaintingStyle.stroke;
      p.strokeWidth = 1.0;
      p.color = col.withValues(alpha: 0.6 * a);
      canvas.drawCircle(cc, rr, p);
      p.style = PaintingStyle.fill;
      p.color = AppColors.white.withValues(alpha: 0.4 * a);
      canvas.drawCircle(cc.translate(rr * 0.2, -rr * 0.15), rr * 0.2, p);
    }
  }

  /// Repaint when the clock or scroll progress changes.
  @override
  bool shouldRepaint(covariant MicrobesPainter old) =>
      old.time != time || old.progress != progress;
}
