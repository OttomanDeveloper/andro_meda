import 'package:safeandromeda/core/hooks/hooks.dart';

/// Distant backdrop for the era: mountain ridge, a row of conifer silhouettes,
/// and a far flock of pterodactyls drifting across the sky.
class SceneryPainter extends CustomPainter {
  /// [progress] doubles as the fade-in alpha for the whole backdrop.
  const SceneryPainter({required this.progress, required this.time});
  final double progress; // era scroll progress 0..1
  final double time; // global animation clock, seconds

  /// Draws ridge, trees, then the flying flock back-to-front.
  @override
  void paint(Canvas canvas, Size size) {
    final double sceneOpacity = progress.clamp(0.0, 1.0);
    if (sceneOpacity < 0.05) return; // skip until the era is barely on screen
    final Paint paint = Paint();

    // Mountains in background
    final Path mountains = Path();
    mountains.moveTo(0, size.height * 0.55);
    mountains.lineTo(size.width * 0.1, size.height * 0.35);
    mountains.lineTo(size.width * 0.2, size.height * 0.5);
    mountains.lineTo(size.width * 0.3, size.height * 0.3);
    mountains.lineTo(size.width * 0.42, size.height * 0.48);
    mountains.lineTo(size.width * 0.55, size.height * 0.28);
    mountains.lineTo(size.width * 0.65, size.height * 0.42);
    mountains.lineTo(size.width * 0.75, size.height * 0.32);
    mountains.lineTo(size.width * 0.88, size.height * 0.45);
    mountains.lineTo(size.width, size.height * 0.38);
    mountains.lineTo(size.width, size.height * 0.55);
    mountains.close();

    paint.color = AppColors.giantsBg.withValues(alpha: 0.4 * sceneOpacity);
    canvas.drawPath(mountains, paint);

    // Tree silhouettes along the ground
    final Random r = Random(88); // fixed seed: tree layout is stable per frame
    for (int i = 0; i < 12; i++) {
      final double tx =
          (i / 12) * size.width +
          r.nextDouble() * 30; // evenly spaced, jittered
      final double groundY = size.height * 0.72; // backdrop ground line
      final double treeHeight = 30 + r.nextDouble() * 60;
      final double trunkWidth = 3 + r.nextDouble() * 3;
      final double canopyRadius = 10 + r.nextDouble() * 20;

      paint.color = const Color(
        0xff0a1508,
      ).withValues(alpha: 0.5 * sceneOpacity);

      // Trunk
      canvas.drawRect(
        Rect.fromLTWH(
          tx - trunkWidth / 2,
          groundY - treeHeight,
          trunkWidth,
          treeHeight,
        ),
        paint,
      );

      // Canopy (triangle for conifers)
      final Path canopy = Path();
      canopy.moveTo(tx, groundY - treeHeight - canopyRadius);
      canopy.lineTo(
        tx - canopyRadius,
        groundY - treeHeight + canopyRadius * 0.4,
      );
      canopy.lineTo(
        tx + canopyRadius,
        groundY - treeHeight + canopyRadius * 0.4,
      );
      canopy.close();
      canvas.drawPath(canopy, paint);
    }

    // Flying pterodactyls, V-shaped wings with body
    for (int p = 0; p < 4; p++) {
      final double speed =
          0.08 + p * 0.03; // farther birds in the list move faster
      // Wrap horizontally across [-0.1w .. 1.3w]; stagger start per bird.
      final double px = ((time * speed + p * 0.35) % 1.4 - 0.1) * size.width;
      final double py =
          size.height * (0.08 + p * 0.05) +
          sin(time * 0.6 + p * 2) * 20; // high in sky, gentle bob
      final double wingSpan = 25 + p * 10.0;
      final double wingFlap =
          sin(time * 2.5 + p * 1.7) * 12; // vertical wingtip travel, px

      paint.color = const Color(
        0xff0a1508,
      ).withValues(alpha: 0.55 * sceneOpacity);

      // Body
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(px, py),
          width: wingSpan * 0.25,
          height: 4,
        ),
        paint,
      );

      // Left wing
      final Path leftWing = Path();
      leftWing.moveTo(px - 3, py);
      leftWing.quadraticBezierTo(
        px - wingSpan * 0.5,
        py - wingFlap * 0.6,
        px - wingSpan,
        py - wingFlap,
      );
      leftWing.lineTo(px - wingSpan * 0.8, py - wingFlap + 3);
      leftWing.quadraticBezierTo(px - wingSpan * 0.4, py + 2, px - 3, py + 1);
      leftWing.close();
      canvas.drawPath(leftWing, paint);

      // Right wing
      final Path rightWing = Path();
      rightWing.moveTo(px + 3, py);
      rightWing.quadraticBezierTo(
        px + wingSpan * 0.5,
        py - wingFlap * 0.6,
        px + wingSpan,
        py - wingFlap,
      );
      rightWing.lineTo(px + wingSpan * 0.8, py - wingFlap + 3);
      rightWing.quadraticBezierTo(px + wingSpan * 0.4, py + 2, px + 3, py + 1);
      rightWing.close();
      canvas.drawPath(rightWing, paint);

      // Head on a short neck
      canvas.drawCircle(Offset(px + wingSpan * 0.18, py - 3), 2.5, paint);
      canvas.drawRect(
        Rect.fromLTWH(px + wingSpan * 0.18, py - 3, wingSpan * 0.1, 1.5),
        paint,
      );
    }
  }

  /// Repaint whenever scroll or the animation clock moves.
  @override
  bool shouldRepaint(covariant SceneryPainter old) =>
      old.progress != progress || old.time != time;
}
