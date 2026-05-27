import 'package:safeandromeda/core/hooks/hooks.dart';

class NebulaPainter extends CustomPainter {
  const NebulaPainter({
    required this.progress,
    required this.clouds,
    this.time = 0.0,
  });

  final double progress;
  final List<NebulaCloud> clouds;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < clouds.length; i++) {
      final NebulaCloud cloud = clouds[i];
      final double drift = progress * size.width * cloud.driftSpeed;

      // Ambient drift: slight sinusoidal position shift independent of scroll
      final double ambientDriftX =
          sin(time * 0.3 + i * 1.7) * size.width * 0.008;
      final double ambientDriftY =
          cos(time * 0.25 + i * 2.3) * size.height * 0.005;

      final Offset center = Offset(
        cloud.x * size.width + drift + ambientDriftX,
        cloud.y * size.height + ambientDriftY,
      );

      final double baseOpacity =
          (cloud.opacity * (0.7 + 0.3 * progress)).clamp(0.0, 1.0);

      // Subtle color shift over time: lerp toward a slightly shifted hue
      final HSLColor hsl = HSLColor.fromColor(cloud.color);
      final double hueShift = sin(time * 0.15 + i * 1.1) * 8.0;
      final HSLColor shifted = hsl.withHue((hsl.hue + hueShift) % 360);
      final Color animatedColor = shifted.toColor();

      final double w = cloud.radius * size.width * 2;
      final double h = cloud.radius * size.height * 2;

      // Layer 1: Outer blur (40px, lowest opacity)
      _drawCloudLayer(
        canvas,
        center: center,
        width: w * 1.4,
        height: h * 1.4,
        color: animatedColor,
        opacity: baseOpacity * 0.15,
        blurSigma: 40,
      );

      // Layer 2: Mid blur (25px)
      _drawCloudLayer(
        canvas,
        center: center,
        width: w * 1.15,
        height: h * 1.15,
        color: animatedColor,
        opacity: baseOpacity * 0.4,
        blurSigma: 25,
      );

      // Layer 3: Inner core (10px, highest opacity)
      _drawCloudLayer(
        canvas,
        center: center,
        width: w,
        height: h,
        color: animatedColor,
        opacity: baseOpacity,
        blurSigma: 10,
      );
    }
  }

  void _drawCloudLayer(
    Canvas canvas, {
    required Offset center,
    required double width,
    required double height,
    required Color color,
    required double opacity,
    required double blurSigma,
  }) {
    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: opacity * 0.3),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(
        Rect.fromCenter(center: center, width: width, height: height),
      )
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant NebulaPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.time != time;
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
