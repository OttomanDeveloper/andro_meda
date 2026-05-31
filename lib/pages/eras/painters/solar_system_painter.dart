import 'package:safeandromeda/core/hooks/hooks.dart';

/// The Solar System: a pulsing sun with lens flare, eight orbiting planets
/// (rings, trails, moon, labels), an asteroid belt, plus wandering rogue
/// planets and comets on eccentric orbits.
class SolarSystemPainter extends CustomPainter {
  const SolarSystemPainter({
    required this.progress,
    required this.time,
    required this.viewportHeight,
    required this.viewportWidth,
  });

  /// Era scroll progress, 0..1; doubled into [opacity] for a fast reveal.
  final double progress;

  /// Global animation clock in seconds; drives orbits, pulse and tails.
  final double time;

  /// Viewport height in px; orbit/sun sizing is keyed to it.
  final double viewportHeight;

  /// Viewport width in px; orbit/sun sizing is keyed to it.
  final double viewportWidth;

  /// Draws sun, rogue planets, the eight planets, asteroid belt and comets,
  /// all scaled to the viewport and gated by [opacity].
  @override
  void paint(Canvas canvas, Size size) {
    final double vw = viewportWidth;
    final double vh = viewportHeight;
    // Centre the system: horizontally centred and vertically at the canvas
    // middle, so it sits in the viewport centre through the era's main view.
    final Offset sun = Offset(vw * 0.5, size.height * 0.5);
    final double opacity = (progress * 2.0).clamp(
      0.0,
      1.0,
    ); // reaches full at progress 0.5

    final Paint paint = Paint();

    // --- SUN ---
    // Corona pulsing: ±8% size breathing.
    final double coronaPulse = 1.0 + sin(time * 1.5) * 0.08;

    // Atmospheric glow
    paint.color = AppColors.solarSun.withValues(alpha: 0.06 * opacity);
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, vh * 0.15);
    canvas.drawCircle(sun, vh * 0.2 * coronaPulse, paint);

    // Outer glow
    paint.color = AppColors.solarSun.withValues(alpha: 0.12 * opacity);
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, vh * 0.08);
    canvas.drawCircle(sun, vh * 0.1 * coronaPulse, paint);

    // Inner glow
    paint.color = AppColors.solarSun.withValues(alpha: 0.3 * opacity);
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, vh * 0.04);
    canvas.drawCircle(sun, vh * 0.06, paint);

    // Sun core
    paint.color = AppColors.solarSun.withValues(alpha: opacity);
    paint.maskFilter = null;
    canvas.drawCircle(sun, vh * 0.035, paint);

    // Bright white center
    paint.color = AppColors.white.withValues(alpha: 0.7 * opacity);
    canvas.drawCircle(sun, vh * 0.015, paint);

    // Lens flare, cross
    paint.color = AppColors.solarSun.withValues(alpha: 0.2 * opacity);
    paint.strokeWidth = 1.5;
    paint.style = PaintingStyle.stroke;
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(
      Offset(sun.dx - vw * 0.15, sun.dy),
      Offset(sun.dx + vw * 0.15, sun.dy),
      paint,
    );
    canvas.drawLine(
      Offset(sun.dx, sun.dy - vh * 0.1),
      Offset(sun.dx, sun.dy + vh * 0.1),
      paint,
    );
    // Diagonal flares
    paint.color = AppColors.solarSun.withValues(alpha: 0.1 * opacity);
    canvas.drawLine(
      Offset(sun.dx - vw * 0.08, sun.dy - vh * 0.06),
      Offset(sun.dx + vw * 0.08, sun.dy + vh * 0.06),
      paint,
    );
    canvas.drawLine(
      Offset(sun.dx - vw * 0.06, sun.dy + vh * 0.05),
      Offset(sun.dx + vw * 0.06, sun.dy - vh * 0.05),
      paint,
    );
    paint.style = PaintingStyle.fill;
    paint.maskFilter = null;

    // --- ROGUE PLANETS wandering through ---
    _drawRoguePlanets(canvas, sun, vw, vh, opacity);

    // --- PLANETS ---
    // Fields: name, orbit radiusX (of vw), radiusY (of vh), color, dot size,
    // orbital speed, hasRings. radiusY < radiusX gives the tilted-ellipse look.
    const List<_Planet> planets = [
      _Planet('Mercury', 0.10, 0.07, Color(0xffaa8866), 4, 4.0, false),
      _Planet('Venus', 0.16, 0.11, Color(0xffeebb66), 6, 2.5, false),
      _Planet('Earth', 0.23, 0.16, Color(0xff4488cc), 7, 1.8, false),
      _Planet('Mars', 0.30, 0.21, Color(0xffcc4422), 5, 1.2, false),
      _Planet('Jupiter', 0.42, 0.30, Color(0xffddaa66), 14, 0.6, false),
      _Planet('Saturn', 0.52, 0.37, Color(0xffccbb88), 12, 0.4, true),
      _Planet('Uranus', 0.60, 0.42, Color(0xff99e0ee), 9, 0.25, true),
      _Planet('Neptune', 0.67, 0.47, Color(0xff4060dd), 8, 0.18, false),
    ];

    for (int i = 0; i < planets.length; i++) {
      final _Planet p = planets[i];
      final double appear =
          (i / planets.length) * 0.3; // inner planets reveal first
      final double localProg = ((opacity - appear) / 0.4).clamp(
        0.0,
        1.0,
      ); // per-planet 0..1
      if (localProg <= 0) continue;

      final double orbitW = p.radiusX * vw;
      final double orbitH = p.radiusY * vh;

      // Orbit ring, sweeps in from 0 to a full circle as the planet reveals.
      final double sweep = localProg * pi * 2;
      paint.color = AppColors.white.withValues(alpha: 0.2 * localProg);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 0.8;
      canvas.drawArc(
        Rect.fromCenter(center: sun, width: orbitW * 2, height: orbitH * 2),
        0,
        sweep,
        false,
        paint,
      );
      paint.style = PaintingStyle.fill;

      // Planet position on its ellipse; i*1.2 staggers starting angles.
      final double angle = time * p.speed * 0.8 + i * 1.2;
      final double px = sun.dx + orbitW * cos(angle);
      final double py = sun.dy + orbitH * sin(angle);
      final double planetR = p.size * localProg;

      // Orbital trail: 8 fading echoes behind the planet along its arc.
      for (int t = 8; t >= 1; t--) {
        final double ta = angle - (pi / 5) * t / 8; // trail spans pi/5 of arc
        final double tx = sun.dx + orbitW * cos(ta);
        final double ty = sun.dy + orbitH * sin(ta);
        paint.color = p.color.withValues(alpha: 0.12 * localProg * (1 - t / 8));
        canvas.drawCircle(Offset(tx, ty), planetR * (1 - t / 16), paint);
      }

      // Planet glow
      paint.color = p.color.withValues(alpha: 0.25 * localProg);
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, planetR * 2);
      canvas.drawCircle(Offset(px, py), planetR * 2.5, paint);
      paint.maskFilter = null;

      // Saturn rings
      if (p.hasRings) {
        paint.color = p.color.withValues(alpha: 0.35 * localProg);
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(px, py),
            width: planetR * 5,
            height: planetR * 1.5,
          ),
          paint,
        );
        paint.strokeWidth = 1;
        paint.color = p.color.withValues(alpha: 0.2 * localProg);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(px, py),
            width: planetR * 6.5,
            height: planetR * 2,
          ),
          paint,
        );
        paint.style = PaintingStyle.fill;
      }

      // Planet core
      paint.color = p.color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(px, py), planetR, paint);

      // Light-side highlight: offset toward the sun so planets look lit.
      final double sa = atan2(
        py - sun.dy,
        px - sun.dx,
      ); // angle from sun to planet
      paint.color = AppColors.white.withValues(alpha: 0.3 * localProg);
      canvas.drawCircle(
        Offset(px - cos(sa) * planetR * 0.3, py - sin(sa) * planetR * 0.3),
        planetR * 0.5,
        paint,
      );

      // Earth's moon (Earth is index 2).
      if (i == 2) {
        final double moonAngle = time * 4.0; // fast lunar orbit
        final double moonDist = planetR * 3;
        final double mx = px + cos(moonAngle) * moonDist;
        final double my = py + sin(moonAngle) * moonDist * 0.5;
        paint.color = AppColors.white.withValues(alpha: 0.6 * localProg);
        canvas.drawCircle(Offset(mx, my), 2.5 * localProg, paint);
      }

      // Planet name: appears only once the planet is mostly revealed.
      if (localProg > 0.6) {
        final double labelAlpha = ((localProg - 0.6) / 0.4).clamp(0.0, 0.4);
        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: p.name,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: labelAlpha),
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(px + planetR + 6, py - 6));
      }
    }

    // --- ASTEROID BELT between Mars and Jupiter ---
    final double beltAppear = ((opacity - 0.2) / 0.3).clamp(0.0, 1.0);
    if (beltAppear > 0) {
      final Random r = Random(55); // fixed seed keeps the belt stable
      paint.color = AppColors.white.withValues(alpha: 0.15 * beltAppear);
      for (int a = 0; a < 60; a++) {
        final double aRadius =
            0.35 +
            r.nextDouble() * 0.05; // between Mars(0.30) and Jupiter(0.42)
        final double aAngle =
            r.nextDouble() * pi * 2 + time * 0.15; // slow belt rotation
        final double ax = sun.dx + aRadius * vw * cos(aAngle);
        final double ay =
            sun.dy +
            aRadius * vh * 0.72 * sin(aAngle); // 0.72 = belt ellipse tilt
        canvas.drawCircle(Offset(ax, ay), 0.8 + r.nextDouble() * 1.2, paint);
      }
    }

    // --- COMETS on eccentric orbits, tails blown away from the sun ---
    _drawComets(canvas, sun, vw, vh, opacity);
  }

  /// Dark, unbound planets drifting across the scene with a sun-lit rim.
  void _drawRoguePlanets(
    Canvas canvas,
    Offset center,
    double vw,
    double vh,
    double opacity,
  ) {
    if (opacity < 0.4) return;
    final double vis = ((opacity - 0.4) / 0.4).clamp(
      0.0,
      1.0,
    ); // 0..1 once past 0.4
    final Paint p = Paint();

    for (int i = 0; i < 3; i++) {
      final Random rnd = Random(i + 90); // per-rogue stable seed
      final double speed =
          0.01 + rnd.nextDouble() * 0.012; // slow crossing speed
      final double cross =
          (time * speed + rnd.nextDouble()) % 1.3 -
          0.15; // -0.15..1.15 of width
      final double rx = cross * vw;
      final double ry =
          center.dy +
          (rnd.nextDouble() - 0.5) * vh * 0.85; // ±42% of vh around centre
      final double pr = 6 + rnd.nextDouble() * 7; // body radius 6..13 px

      // Faint atmosphere glow so the dark body reads against space.
      p.color = AppColors.solarFlare.withValues(alpha: 0.24 * vis);
      p.maskFilter = MaskFilter.blur(BlurStyle.normal, pr * 1.0);
      canvas.drawCircle(Offset(rx, ry), pr * 1.7, p);
      p.maskFilter = null;

      // Dark rogue body.
      p.color = const Color(0xff181c26).withValues(alpha: 0.95 * vis);
      canvas.drawCircle(Offset(rx, ry), pr, p);

      // Sun-lit rim.
      final double sa = atan2(center.dy - ry, center.dx - rx);
      p.color = AppColors.solarSun.withValues(alpha: 0.6 * vis);
      canvas.drawCircle(
        Offset(rx + cos(sa) * pr * 0.6, ry + sin(sa) * pr * 0.6),
        pr * 0.45,
        p,
      );
    }
  }

  /// Comets on eccentric orbits; tails grow near the sun and point away from it.
  void _drawComets(
    Canvas canvas,
    Offset sun,
    double vw,
    double vh,
    double opacity,
  ) {
    if (opacity < 0.3) return;
    final double vis = ((opacity - 0.3) / 0.4).clamp(
      0.0,
      1.0,
    ); // 0..1 once past 0.3
    const Color cometColor = Color(0xffaad8ff);
    final Paint p = Paint();

    for (int i = 0; i < 4; i++) {
      final double a =
          (0.32 + i * 0.10) * vw; // semi-major axis, widens per comet
      final double e = 0.76 + i * 0.04; // eccentricity, highly elongated
      final double ang =
          time * (0.6 + i * 0.16) * 0.5 + i * 1.7; // true anomaly
      final double r =
          a * (1 - e * e) / (1 + e * cos(ang)); // conic orbit radius
      const double tilt = 0.5; // flatten orbit into the disk plane
      final Offset pos = Offset(
        sun.dx + r * cos(ang),
        sun.dy + r * sin(ang) * tilt,
      );

      final double dx = pos.dx - sun.dx;
      final double dy = pos.dy - sun.dy;
      final double len = sqrt(dx * dx + dy * dy) + 0.001;
      final double ux = dx / len;
      final double uy = dy / len;

      // Tail grows toward perihelion, blown radially away from the sun.
      final double peri = a * (1 - e); // perihelion distance
      final double tailLen =
          vh *
          (0.09 + 0.26 * (peri / r).clamp(0.0, 1.0)); // longest near the sun

      for (int s = 1; s <= 16; s++) {
        final double t = s / 16; // 0 at head, 1 at tail tip
        final double curve =
            sin(t * pi) * tailLen * 0.12; // slight bow, peaks mid-tail
        final double tx = pos.dx + ux * tailLen * t - uy * curve;
        final double ty = pos.dy + uy * tailLen * t + ux * curve;
        p.color = cometColor.withValues(
          alpha: (0.6 * (1 - t) * vis).clamp(0.0, 0.6),
        );
        p.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
        canvas.drawCircle(Offset(tx, ty), 2.8 * (1 - t) + 0.7, p);
      }
      p.maskFilter = null;

      // Glowing head.
      p.color = cometColor.withValues(alpha: 0.55 * vis);
      p.maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
      canvas.drawCircle(pos, 5.5, p);
      p.maskFilter = null;
      p.color = AppColors.white.withValues(alpha: vis);
      canvas.drawCircle(pos, 2.3, p);
    }
  }

  /// Repaint when scroll progress or the clock changes.
  @override
  bool shouldRepaint(covariant SolarSystemPainter old) =>
      old.progress != progress || old.time != time;
}

/// One planet's static orbit data (no drawing logic of its own).
class _Planet {
  const _Planet(
    this.name,
    this.radiusX,
    this.radiusY,
    this.color,
    this.size,
    this.speed,
    this.hasRings,
  );

  /// Label text.
  final String name;

  /// Orbit horizontal radius as a fraction of viewport width.
  final double radiusX;

  /// Orbit vertical radius as a fraction of viewport height (< radiusX = tilt).
  final double radiusY;

  /// Body fill color.
  final Color color;

  /// Drawn dot radius in px at full reveal.
  final double size;

  /// Angular speed multiplier; higher = faster orbit.
  final double speed;

  /// Whether to draw Saturn-style rings.
  final bool hasRings;
}
