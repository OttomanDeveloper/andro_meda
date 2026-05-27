import 'package:safeandromeda/core/hooks/hooks.dart';

class OrbitPainter extends CustomPainter {
  const OrbitPainter({
    required this.progress,
    required this.orbits,
    required this.centerColor,
    required this.centerRadius,
  });

  final double progress;
  final List<OrbitRing> orbits;
  final Color centerColor;
  final double centerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.35, size.height * 0.45);

    final Paint sunPaint = Paint()..color = centerColor;
    canvas.drawCircle(center, centerRadius, sunPaint);

    final Paint glowPaint = Paint()
      ..color = centerColor.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, centerRadius * 3, glowPaint);

    final double drawProgress = progress.clamp(0.0, 1.0);

    for (int i = 0; i < orbits.length; i++) {
      final OrbitRing orbit = orbits[i];
      final double orbitAppear = (i / orbits.length) * 0.5;
      final double localProgress =
          ((drawProgress - orbitAppear) / 0.5).clamp(0.0, 1.0);

      if (localProgress <= 0.0) continue;

      final Paint ringPaint = Paint()
        ..color = AppColors.white.withValues(alpha: 0.06 * localProgress)
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

      final double angle = progress * orbit.speed * pi * 2;
      final double px = center.dx + orbit.radiusX * size.width * cos(angle);
      final double py = center.dy + orbit.radiusY * size.height * sin(angle);

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
      oldDelegate.progress != progress;
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
