import 'package:safeandromeda/core/hooks/hooks.dart';

/// Draws a three-arm spiral galaxy: dust lanes, star dots, glow, and core.
class GalaxySpiralPainter extends CustomPainter {
  const GalaxySpiralPainter({required this.rotation, required this.progress});

  final double rotation; // total spiral rotation, radians
  final double progress; // era scroll progress, 0..1; scales all opacities

  /// Paints lanes, arms, glow, and core; elements fade in with progress.
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final Paint paint = Paint();
    final Random random = Random(42); // fixed seed keeps star jitter stable

    // Dust lanes - draw darker arcs between spiral arms (behind bright dots)
    final Random dustRandom = Random(43);
    for (int arm = 0; arm < 3; arm++) {
      // Offset each lane by 1/3 turn, plus pi/3 to sit between the arms.
      final double laneOffset = (arm / 3) * pi * 2 + pi / 3 + rotation;
      for (int i = 0; i < 40; i++) {
        final double t = i / 40.0; // 0 at core, 1 at outer edge
        final double r = t * size.width * 0.38; // lane radius
        final double angle = laneOffset + t * pi * 2.8; // ~1.4 turns of wind
        final double x =
            center.dx + r * cos(angle) + (dustRandom.nextDouble() - 0.5) * 8;
        // 0.6 vertical squash tilts the disk for a perspective view.
        final double y =
            center.dy +
            r * sin(angle) * 0.6 +
            (dustRandom.nextDouble() - 0.5) * 5;

        paint.color = AppColors.galaxiesBg.withValues(
          alpha: (0.3 * t * progress).clamp(0.0, 0.3),
        );
        canvas.drawCircle(
          Offset(x, y),
          4.5 + dustRandom.nextDouble() * 6,
          paint,
        );
      }
    }

    // Bright spiral arm dots
    for (int arm = 0; arm < 3; arm++) {
      final double armOffset = arm * (pi * 2 / 3); // arms 120 deg apart

      for (int i = 0; i < 120; i++) {
        final double t = i / 120.0; // 0 at core, 1 at outer edge
        final double spiralRadius = t * size.width * 0.42;
        final double angle = armOffset + rotation + t * pi * 3; // 1.5 turns

        final double jitterX = (random.nextDouble() - 0.5) * 15;
        final double jitterY = (random.nextDouble() - 0.5) * 15;

        final double x = center.dx + spiralRadius * cos(angle) + jitterX;
        final double y = center.dy + spiralRadius * sin(angle) * 0.6 + jitterY;

        // Fade toward the edge so the core reads brightest.
        final double starOpacity = ((1.0 - t) * 0.7 * progress).clamp(0.0, 0.7);
        // Core color near center, arm color outward.
        paint.color = Color.lerp(
          AppColors.galaxiesCore,
          AppColors.galaxiesArm,
          t,
        )!.withValues(alpha: starOpacity);

        // Random base size, shrinking toward the rim.
        final double dotSize =
            (1.3 + random.nextDouble() * 2.6) * (1.0 - t * 0.5);
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }

    // Enhanced center glow: tight white halo over a wide colored bloom.
    paint.color = AppColors.white.withValues(alpha: 0.5 * progress);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 35);
    canvas.drawCircle(center, 35, paint);
    paint.maskFilter = null;

    paint.color = AppColors.galaxiesCore.withValues(alpha: 0.3 * progress);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 70);
    canvas.drawCircle(center, 70, paint);
    paint.maskFilter = null;

    // Galactic core rings
    for (int ring = 0; ring < 4; ring++) {
      final double ringRadius = 8.0 + ring * 6.0; // 8,14,20,26 px
      final double ringOpacity =
          (0.15 - ring * 0.03) * progress; // fade outward
      paint.color = AppColors.galaxiesCore.withValues(
        alpha: ringOpacity.clamp(0.0, 0.15),
      );
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.5;
      canvas.drawCircle(center, ringRadius, paint);
    }
    paint.style = PaintingStyle.fill;

    // Core dot
    paint.color = AppColors.white.withValues(alpha: 0.8 * progress);
    canvas.drawCircle(center, 6, paint);
    paint.color = AppColors.galaxiesCore.withValues(alpha: 0.3 * progress);
    canvas.drawCircle(center, 18, paint);
  }

  /// Repaints when the user spins the disk or the era progress changes.
  @override
  bool shouldRepaint(covariant GalaxySpiralPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.progress != progress;
}
