import 'package:safeandromeda/core/hooks/hooks.dart';

class NebulaPainter extends CustomPainter {
  const NebulaPainter({
    required this.progress,
    required this.clouds,
  });

  final double progress;
  final List<NebulaCloud> clouds;

  @override
  void paint(Canvas canvas, Size size) {
    for (final NebulaCloud cloud in clouds) {
      final double drift = progress * size.width * cloud.driftSpeed;
      final Offset center = Offset(
        cloud.x * size.width + drift,
        cloud.y * size.height,
      );

      final double opacity =
          (cloud.opacity * (0.7 + 0.3 * progress)).clamp(0.0, 1.0);

      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: [
            cloud.color.withValues(alpha: opacity),
            cloud.color.withValues(alpha: opacity * 0.3),
            cloud.color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(
          Rect.fromCenter(
            center: center,
            width: cloud.radius * size.width * 2,
            height: cloud.radius * size.height * 2,
          ),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: cloud.radius * size.width * 2,
          height: cloud.radius * size.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NebulaPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class NebulaCloud {
  const NebulaCloud({
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
    this.opacity = 0.3,
    this.driftSpeed = 0.05,
  });

  final double x;
  final double y;
  final double radius;
  final Color color;
  final double opacity;
  final double driftSpeed;
}
