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

    final double drawProgress = progress.clamp(0.0, 1.0);

    for (int i = 0; i < orbits.length; i++) {
      final OrbitRing orbit = orbits[i];
      final double orbitAppear = (i / orbits.length) * 0.5;
      final double localProgress =
          ((drawProgress - orbitAppear) / 0.5).clamp(0.0, 1.0);

      if (localProgress <= 0.0) continue;

      // Orbital ring with increased opacity
      final Paint ringPaint = Paint()
        ..color =
            AppColors.white.withValues(alpha: 0.13 * localProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: orbit.radiusX * size.width * 2,
          height: orbit.radiusY * size.height * 2,
        ),
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

      // Planet core
      final Paint planetPaint = Paint()..color = orbit.planetColor;
      canvas.drawCircle(
        Offset(px, py),
        orbit.planetSize * localProgress,
        planetPaint,
      );
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
  });

  final double radiusX;
  final double radiusY;
  final Color planetColor;
  final double planetSize;
  final double speed;
}
