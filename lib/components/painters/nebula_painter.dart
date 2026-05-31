import 'package:safeandromeda/core/hooks/hooks.dart';

/// Draws layered, blurred gas clouds that drift with scroll, time, and cursor.
class NebulaPainter extends CustomPainter {
  const NebulaPainter({
    required this.progress,
    required this.clouds,
    this.time = 0.0,
    this.cursorX = 0.0,
    this.cursorY = 0.0,
  });

  /// Era scroll progress in [0, 1]; drives scroll drift and opacity ramp.
  final double progress;

  /// Cloud definitions to render.
  final List<NebulaCloud> clouds;

  /// Global animation clock in seconds; drives ambient drift and hue shift.
  final double time;

  /// Normalized cursor X (-1..1) for parallax.
  final double cursorX;

  /// Normalized cursor Y (-1..1) for parallax.
  final double cursorY;

  /// Draws each cloud as three stacked blur layers for a soft falloff.
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < clouds.length; i++) {
      final NebulaCloud cloud = clouds[i];
      final double drift = progress * size.width * cloud.driftSpeed;

      // Ambient drift: slight sinusoidal position shift independent of scroll
      final double ambientDriftX =
          sin(time * 0.6 + i * 1.7) * size.width * 0.008;
      final double ambientDriftY =
          cos(time * 0.5 + i * 2.3) * size.height * 0.005;

      final Offset center = Offset(
        cloud.x * size.width +
            drift +
            ambientDriftX +
            cursorX * 20.0 * cloud.driftSpeed,
        cloud.y * size.height +
            ambientDriftY +
            cursorY * 15.0 * cloud.driftSpeed,
      );

      // Clouds start at 70% of their opacity and reach full as the era scrolls.
      final double baseOpacity = (cloud.opacity * (0.7 + 0.3 * progress)).clamp(
        0.0,
        1.0,
      );

      // Subtle color shift over time: lerp toward a slightly shifted hue
      final HSLColor hsl = HSLColor.fromColor(cloud.color);
      final double hueShift = sin(time * 0.35 + i * 1.1) * 8.0;
      final HSLColor shifted = hsl.withHue((hsl.hue + hueShift) % 360);
      final Color animatedColor = shifted.toColor();

      final double w = cloud.radius * size.width * 2; // base ellipse width
      final double h = cloud.radius * size.height * 2; // base ellipse height

      // Layer 1: Outer blur (40px, lowest opacity)
      _drawCloudLayer(
        canvas,
        center: center,
        width: w * 1.4,
        height: h * 1.4,
        color: animatedColor,
        opacity: baseOpacity * 0.25,
        blurSigma: 40,
      );

      // Layer 2: Mid blur (25px)
      _drawCloudLayer(
        canvas,
        center: center,
        width: w * 1.15,
        height: h * 1.15,
        color: animatedColor,
        opacity: baseOpacity * 0.6,
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

  /// Paints one radial-gradient ellipse layer, flattened vertically and blurred.
  void _drawCloudLayer(
    Canvas canvas, {
    required Offset center,
    required double width,
    required double height,
    required Color color,
    required double opacity,
    required double blurSigma, // blur radius in px for this layer
  }) {
    final Paint paint = Paint()
      ..shader =
          RadialGradient(
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

    // height * 0.5 squashes the oval flat, reading as a horizontal gas band.
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height * 0.5),
      paint,
    );
  }

  /// Repaints when scroll, clock, or cursor changes.
  @override
  bool shouldRepaint(covariant NebulaPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.time != time ||
      oldDelegate.cursorX != cursorX ||
      oldDelegate.cursorY != cursorY;
}

/// One gas cloud: placement, size, color, and how fast it drifts with scroll.
class NebulaCloud {
  const NebulaCloud({
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
    this.opacity = 0.3,
    this.driftSpeed = 0.05,
  });

  /// Center X as a fraction of canvas width.
  final double x;

  /// Center Y as a fraction of canvas height.
  final double y;

  /// Cloud size as a fraction of canvas dimensions (half-extent).
  final double radius;

  /// Base color before time-driven hue shift.
  final Color color;

  /// Peak opacity in [0, 1] before the scroll ramp.
  final double opacity;

  /// Scroll-linked horizontal drift rate; also scales cursor parallax.
  final double driftSpeed;
}
