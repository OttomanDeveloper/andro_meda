import 'package:safeandromeda/core/hooks/hooks.dart';

class SolarSystemEra extends StatelessWidget {
  const SolarSystemEra({super.key});

  static const int eraIndex = 4;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final int starCount = AppSettings.particleCount(context, desktop: 80);

    return Consumer<CursorProvider>(
      builder: (_, CursorProvider cursor, _) {
        return Consumer<AnimationProvider>(
          builder: (_, AnimationProvider anim, _) {
            return Selector<ScrollProvider, double>(
              selector: (_, ScrollProvider pro) =>
                  (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
              builder: (_, double progress, _) {
                return EraWrapper(
                  eraIndex: eraIndex,
                  backgroundColor: AppColors.solarBg,
                  nextBackgroundColor: AppColors.lifeBg,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: StarFieldPainter(
                            progress: progress,
                            time: anim.time,
                            starCount: starCount,
                            baseColor: AppColors.white,
                            maxOpacity: 0.3,
                            seed: 456,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _SolarSystemPainter(
                            progress: progress,
                            time: anim.time,
                            viewportHeight: size.height,
                            viewportWidth: size.width,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.solarFlare,
                            seed: eraIndex * 100 + 99,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SolarSystemPainter extends CustomPainter {
  const _SolarSystemPainter({
    required this.progress,
    required this.time,
    required this.viewportHeight,
    required this.viewportWidth,
  });

  final double progress;
  final double time;
  final double viewportHeight;
  final double viewportWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double vw = viewportWidth;
    final double vh = viewportHeight;
    final Offset sun = Offset(vw * 0.3, vh * 0.42);
    final double opacity = (progress * 2.0).clamp(0.0, 1.0);

    final Paint paint = Paint();

    // --- SUN ---
    // Corona pulsing
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

    // Lens flare — cross
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

    // --- PLANETS ---
    const List<_Planet> planets = [
      _Planet('Mercury', 0.10, 0.07, Color(0xffaa8866), 4, 4.0, false),
      _Planet('Venus',   0.16, 0.11, Color(0xffeebb66), 6, 2.5, false),
      _Planet('Earth',   0.23, 0.16, Color(0xff4488cc), 7, 1.8, false),
      _Planet('Mars',    0.30, 0.21, Color(0xffcc4422), 5, 1.2, false),
      _Planet('Jupiter', 0.42, 0.30, Color(0xffddaa66), 14, 0.6, false),
      _Planet('Saturn',  0.52, 0.37, Color(0xffccbb88), 12, 0.4, true),
    ];

    for (int i = 0; i < planets.length; i++) {
      final _Planet p = planets[i];
      final double appear = (i / planets.length) * 0.3;
      final double localProg = ((opacity - appear) / 0.4).clamp(0.0, 1.0);
      if (localProg <= 0) continue;

      final double orbitW = p.radiusX * vw;
      final double orbitH = p.radiusY * vh;

      // Orbit ring — sweeps in
      final double sweep = localProg * pi * 2;
      paint.color = AppColors.white.withValues(alpha: 0.2 * localProg);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 0.8;
      canvas.drawArc(
        Rect.fromCenter(center: sun, width: orbitW * 2, height: orbitH * 2),
        0, sweep, false, paint,
      );
      paint.style = PaintingStyle.fill;

      // Planet position
      final double angle = time * p.speed * 0.8 + i * 1.2;
      final double px = sun.dx + orbitW * cos(angle);
      final double py = sun.dy + orbitH * sin(angle);
      final double planetR = p.size * localProg;

      // Orbital trail
      for (int t = 8; t >= 1; t--) {
        final double ta = angle - (pi / 5) * t / 8;
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
        canvas.drawOval(Rect.fromCenter(
          center: Offset(px, py),
          width: planetR * 5, height: planetR * 1.5,
        ), paint);
        paint.strokeWidth = 1;
        paint.color = p.color.withValues(alpha: 0.2 * localProg);
        canvas.drawOval(Rect.fromCenter(
          center: Offset(px, py),
          width: planetR * 6.5, height: planetR * 2,
        ), paint);
        paint.style = PaintingStyle.fill;
      }

      // Planet core
      paint.color = p.color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(px, py), planetR, paint);

      // Light-side highlight
      final double sa = atan2(py - sun.dy, px - sun.dx);
      paint.color = AppColors.white.withValues(alpha: 0.3 * localProg);
      canvas.drawCircle(
        Offset(px - cos(sa) * planetR * 0.3, py - sin(sa) * planetR * 0.3),
        planetR * 0.5, paint,
      );

      // Earth's moon
      if (i == 2) {
        final double moonAngle = time * 4.0;
        final double moonDist = planetR * 3;
        final double mx = px + cos(moonAngle) * moonDist;
        final double my = py + sin(moonAngle) * moonDist * 0.5;
        paint.color = AppColors.white.withValues(alpha: 0.6 * localProg);
        canvas.drawCircle(Offset(mx, my), 2.5 * localProg, paint);
      }

      // Planet name
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
      final Random r = Random(55);
      paint.color = AppColors.white.withValues(alpha: 0.15 * beltAppear);
      for (int a = 0; a < 60; a++) {
        final double aRadius = 0.35 + r.nextDouble() * 0.05;
        final double aAngle = r.nextDouble() * pi * 2 + time * 0.15;
        final double ax = sun.dx + aRadius * vw * cos(aAngle);
        final double ay = sun.dy + aRadius * vh * 0.72 * sin(aAngle);
        canvas.drawCircle(Offset(ax, ay), 0.8 + r.nextDouble() * 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SolarSystemPainter old) =>
      old.progress != progress || old.time != time;
}

class _Planet {
  const _Planet(this.name, this.radiusX, this.radiusY, this.color,
      this.size, this.speed, this.hasRings);
  final String name;
  final double radiusX;
  final double radiusY;
  final Color color;
  final double size;
  final double speed;
  final bool hasRings;
}
