import 'package:safeandromeda/core/hooks/hooks.dart';

/// Other galaxies populating the young universe: several wander slowly across
/// the field, and a featured pair runs a periodic collision, swinging close
/// with tidal tails and a starburst flash, then drifting apart on a slow loop.
class DriftingGalaxiesPainter extends CustomPainter {
  const DriftingGalaxiesPainter({required this.progress, required this.time});

  /// Era scroll progress, 0..1; gates the fade-in.
  final double progress;

  /// Global animation clock in seconds; drives drift and the collision cycle.
  final double time;

  /// Fades the whole field in over progress 0.03..0.15, then draws drifters
  /// and the featured colliding pair.
  @override
  void paint(Canvas canvas, Size size) {
    final double appear = ((progress - 0.03) / 0.12).clamp(
      0.0,
      1.0,
    ); // 0..1 fade-in
    if (appear <= 0) return;

    _drawDrifters(canvas, size, appear);
    _drawCollidingPair(canvas, size, appear);
  }

  /// One small spiral galaxy: tilted halo, two trailing arms, bright core.
  void _drawGalaxy(
    Canvas canvas,
    Offset c,
    double radius,
    double rotation,
    double tilt,
    Color armColor,
    double alpha,
  ) {
    final Paint p = Paint();

    // Disk halo.
    p.color = armColor.withValues(alpha: 0.10 * alpha);
    p.maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.6);
    canvas.drawOval(
      Rect.fromCenter(center: c, width: radius * 2, height: radius * 2 * tilt),
      p,
    );
    p.maskFilter = null;

    // Spiral arms as dotted logarithmic curves.
    const int arms = 2;
    const int pts = 22; // dots per arm
    for (int a = 0; a < arms; a++) {
      final double base = (a / arms) * pi * 2 + rotation; // arm start angle
      for (int i = 1; i <= pts; i++) {
        final double t = i / pts; // 0 at core, 1 at arm tip
        final double ang = base + t * pi * 2.4; // 2.4 = arm wind, ~1.2 turns
        final double rr = t * radius;
        final double x = c.dx + cos(ang) * rr;
        final double y = c.dy + sin(ang) * rr * tilt;
        p.color = armColor.withValues(
          alpha: (0.55 * (1 - t * 0.6) * alpha).clamp(0.0, 0.6),
        );
        canvas.drawCircle(Offset(x, y), 1.0 + (1 - t) * 1.3, p);
      }
    }

    // Core.
    p.color = AppColors.white.withValues(alpha: 0.45 * alpha);
    p.maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.3);
    canvas.drawCircle(c, radius * 0.22, p);
    p.maskFilter = null;
    p.color = AppColors.white.withValues(alpha: 0.9 * alpha);
    canvas.drawCircle(c, radius * 0.08, p);
  }

  /// Background galaxies wandering slowly across the field.
  void _drawDrifters(Canvas canvas, Size size, double appear) {
    const int n = 5;
    for (int i = 0; i < n; i++) {
      final Random rnd = Random(i + 300); // per-galaxy stable seed
      final double bx =
          0.1 + rnd.nextDouble() * 0.8; // base x, 0.1..0.9 of width
      final double by =
          0.1 + rnd.nextDouble() * 0.8; // base y, 0.1..0.9 of height
      final double x =
          bx * size.width +
          sin(time * 0.07 + i * 2) * size.width * 0.05; // ±5% drift
      final double y =
          by * size.height +
          cos(time * 0.05 + i) * size.height * 0.02; // ±2% drift
      final double r =
          size.width *
          (0.022 + rnd.nextDouble() * 0.018); // radius 2.2..4% width
      final double tilt =
          0.35 + rnd.nextDouble() * 0.5; // disk height/width ratio
      final Color col = i.isEven
          ? AppColors.galaxiesArm
          : AppColors.galaxiesDeep;
      _drawGalaxy(
        canvas,
        Offset(x, y),
        r,
        time * (0.2 + rnd.nextDouble() * 0.3) + i,
        tilt,
        col,
        0.55 * appear,
      );
    }
  }

  /// Featured pair: they swing close (tidal tails + starburst) then apart.
  void _drawCollidingPair(Canvas canvas, Size size, double appear) {
    // Lower in the (2x viewport) canvas so the pair is on screen at full
    // brightness through the mid-era, not scrolling off the top as it fades in.
    final Offset c = Offset(size.width * 0.28, size.height * 0.58);
    final double maxSep = size.width * 0.13; // farthest the pair drifts apart
    final double minSep = size.width * 0.018; // closest approach at collision
    final double cycle = 0.5 + 0.5 * cos(time * 0.4); // 0 closest, 1 apart
    final double sep = minSep + (maxSep - minSep) * cycle;
    final double ang = time * 0.13; // slow rotation of the pair's axis
    const double tilt = 0.6; // separation flattened into the disk plane
    final double r = size.width * 0.05; // galaxy radius

    final Offset a = Offset(
      c.dx + cos(ang) * sep,
      c.dy + sin(ang) * sep * tilt,
    );
    final Offset b = Offset(
      c.dx - cos(ang) * sep,
      c.dy - sin(ang) * sep * tilt,
    );

    final double closeness = 1 - cycle; // 1 at collision

    // Starburst glow as the disks interpenetrate.
    if (closeness > 0.45) {
      final double burst = (closeness - 0.45) / 0.55;
      final Paint g = Paint()
        ..color = AppColors.firstStarsBright.withValues(
          alpha: 0.22 * burst * appear,
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 1.6);
      canvas.drawCircle(c, r * (0.5 + burst * 0.7), g);
    }

    // Tidal tails streaming away from each galaxy as they pass.
    if (closeness > 0.35) {
      final double s = (closeness - 0.35) / 0.65 * appear;
      _drawTidalTail(canvas, a, c, r, s, AppColors.galaxiesArm);
      _drawTidalTail(canvas, b, c, r, s, AppColors.galaxiesCore);
    }

    _drawGalaxy(canvas, a, r, time * 0.5, tilt, AppColors.galaxiesArm, appear);
    _drawGalaxy(
      canvas,
      b,
      r * 0.85,
      -time * 0.6,
      tilt,
      AppColors.galaxiesCore,
      appear,
    );
  }

  /// A curved stream of stars pulled out of [g], arcing away from centre [c].
  void _drawTidalTail(
    Canvas canvas,
    Offset g,
    Offset c,
    double r,
    double strength,
    Color color,
  ) {
    if (strength <= 0) return;
    final Paint p = Paint();
    final double dx = g.dx - c.dx;
    final double dy = g.dy - c.dy;
    final double len = sqrt(dx * dx + dy * dy) + 0.001;
    final double ux = dx / len;
    final double uy = dy / len;
    final double perpX = -uy;
    final double perpY = ux;

    for (int i = 1; i <= 16; i++) {
      final double t = i / 16; // 0 at galaxy, 1 at tail tip
      final double dist =
          r * 0.8 + t * r * 3.2 * strength; // tail reach grows with strength
      final double curve =
          sin(t * pi) * r * 1.3; // sideways bow, peaks mid-tail
      final double x = g.dx + ux * dist + perpX * curve;
      final double y = g.dy + uy * dist + perpY * curve;
      p.color = color.withValues(
        alpha: (0.4 * (1 - t) * strength).clamp(0.0, 0.4),
      );
      canvas.drawCircle(Offset(x, y), 1.3 * (1 - t * 0.5), p);
    }
  }

  /// Repaint when the clock or scroll progress changes.
  @override
  bool shouldRepaint(covariant DriftingGalaxiesPainter old) =>
      old.time != time || old.progress != progress;
}
