import 'package:safeandromeda/core/hooks/hooks.dart';

class OrbitPainter extends CustomPainter {
  const OrbitPainter({
    required this.progress,
    required this.orbits,
    required this.centerColor,
    required this.centerRadius,
    this.time = 0.0,
  });

  final double progress;
  final List<OrbitRing> orbits;
  final Color centerColor;
  final double centerRadius;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.35, size.height * 0.45);

    // Sun: multi-layer glow
    // Outermost glow (8x radius)
    final Paint outerGlowPaint = Paint()
      ..color = centerColor.withValues(alpha: 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    canvas.drawCircle(center, centerRadius * 8, outerGlowPaint);

    // Mid glow (5x radius)
    final Paint midGlowPaint = Paint()
      ..color = centerColor.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(center, centerRadius * 5, midGlowPaint);

    // Inner glow (3x radius)
    final Paint innerGlowPaint = Paint()
      ..color = centerColor.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, centerRadius * 3, innerGlowPaint);

    // Sun core
    final Paint sunPaint = Paint()..color = centerColor;
    canvas.drawCircle(center, centerRadius, sunPaint);

    // Lens flare horizontal
    final Paint flarePaint = Paint()
      ..color = centerColor.withValues(alpha: 0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(
      Offset(center.dx - centerRadius * 8, center.dy),
      Offset(center.dx + centerRadius * 8, center.dy),
      flarePaint,
    );
    // Lens flare vertical
    canvas.drawLine(
      Offset(center.dx, center.dy - centerRadius * 5),
      Offset(center.dx, center.dy + centerRadius * 5),
      flarePaint,
    );

    // Atmospheric glow
    final Paint atmoGlowPaint = Paint()
      ..color = centerColor.withValues(alpha: 0.03)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    canvas.drawCircle(center, centerRadius * 12, atmoGlowPaint);

    final double drawProgress = progress.clamp(0.0, 1.0);

    for (int i = 0; i < orbits.length; i++) {
      final OrbitRing orbit = orbits[i];
      final double orbitAppear = (i / orbits.length) * 0.5;
      final double localProgress =
          ((drawProgress - orbitAppear) / 0.5).clamp(0.0, 1.0);

      if (localProgress <= 0.0) continue;

      // Orbital ring draws itself progressively as the era scrolls
      final double sweepAngle = localProgress * pi * 2;
      final Paint ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color =
            AppColors.white.withValues(alpha: 0.13 * localProgress);

      canvas.drawArc(
        Rect.fromCenter(
          center: center,
          width: orbit.radiusX * size.width * 2,
          height: orbit.radiusY * size.height * 2,
        ),
        0, // start angle
        sweepAngle, // sweep
        false,
        ringPaint,
      );

      // Planet angle: uses both scroll progress and time for continuous orbit
      final double angle =
          progress * orbit.speed * pi * 2 + time * orbit.speed * 0.5;
      final double px = center.dx + orbit.radiusX * size.width * cos(angle);
      final double py = center.dy + orbit.radiusY * size.height * sin(angle);

      // Orbital trail: 30 degree arc behind the planet
      const double trailAngle = pi / 6; // 30 degrees
      const int trailSegments = 12;
      for (int t = trailSegments; t >= 1; t--) {
        final double segAngle = angle - (trailAngle * t / trailSegments);
        final double tx =
            center.dx + orbit.radiusX * size.width * cos(segAngle);
        final double ty =
            center.dy + orbit.radiusY * size.height * sin(segAngle);
        final double trailOpacity =
            0.15 * localProgress * (1.0 - t / trailSegments);
        final Paint trailPaint = Paint()
          ..color = orbit.planetColor.withValues(alpha: trailOpacity);
        canvas.drawCircle(
          Offset(tx, ty),
          orbit.planetSize * localProgress * (1.0 - t / (trailSegments * 2)),
          trailPaint,
        );
      }

      // Planet glow halo
      final Paint planetGlowPaint = Paint()
        ..color = orbit.planetColor.withValues(alpha: 0.25 * localProgress)
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, orbit.planetSize * 1.5);
      canvas.drawCircle(
        Offset(px, py),
        orbit.planetSize * localProgress * 2.5,
        planetGlowPaint,
      );

      // Saturn rings on 5th planet (index 4)
      if (i == 4) {
        final Paint ringsPaint = Paint()
          ..color = orbit.planetColor.withValues(alpha: 0.3 * localProgress)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(px, py),
            width: orbit.planetSize * 4,
            height: orbit.planetSize * 1.2,
          ),
          ringsPaint,
        );
      }

      // Planet core
      final Paint planetPaint = Paint()..color = orbit.planetColor;
      canvas.drawCircle(
        Offset(px, py),
        orbit.planetSize * localProgress,
        planetPaint,
      );

      // Lit-side gradient highlight
      final double sunAngle = atan2(py - center.dy, px - center.dx);
      final Paint highlightPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment(-cos(sunAngle) * 0.5, -sin(sunAngle) * 0.5),
          radius: 1.0,
          colors: [
            orbit.planetColor.withValues(alpha: 0.6 * localProgress),
            orbit.planetColor.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(px, py), radius: orbit.planetSize));
      canvas.drawCircle(Offset(px, py), orbit.planetSize * localProgress, highlightPaint);

      // Planet name label
      if (orbit.name.isNotEmpty && localProgress > 0.5) {
        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: orbit.name,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3 * localProgress),
              fontSize: 9,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(px + orbit.planetSize + 4, py - 5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant OrbitPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.time != time;
}

class OrbitRing {
  const OrbitRing({
    required this.radiusX,
    required this.radiusY,
    required this.planetColor,
    required this.planetSize,
    this.speed = 1.0,
    this.name = '',
  });

  final double radiusX;
  final double radiusY;
  final Color planetColor;
  final double planetSize;
  final double speed;
  final String name;
}
