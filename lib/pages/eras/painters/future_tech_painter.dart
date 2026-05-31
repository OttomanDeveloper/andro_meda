import 'package:safeandromeda/core/hooks/hooks.dart';

/// A tech-future backdrop: a faint grid, three pulsing neon-blue accent lines,
/// and dot particles drifting upward. Colors flip light/dark with the era's
/// background brightness.
class FutureTechPainter extends CustomPainter {
  const FutureTechPainter({
    required this.progress,
    required this.lightProgress,
  });

  /// Era scroll progress, 0..1; drives line pulse and particle drift.
  final double progress;

  /// Background brightness, 0..1; switches palette and fades the grid in.
  final double lightProgress;

  /// Draws the three layers back to front.
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    _drawGrid(canvas, w, h);
    _drawAccentLines(canvas, w, h);
    _drawDigitalParticles(canvas, w, h);
  }

  /// Even grid of thin lines that fades in as the background lightens.
  void _drawGrid(Canvas canvas, double w, double h) {
    // Subtle grid pattern that fades in as background lightens
    final double gridOpacity = (lightProgress * 0.1).clamp(0.0, 0.1);
    if (gridOpacity < 0.003) return;

    final bool isDark = lightProgress < 0.5; // dark half uses white lines
    final Color gridColor = isDark
        ? AppColors.white.withValues(alpha: gridOpacity)
        : AppColors.portfolioText.withValues(alpha: gridOpacity);

    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    final double spacing = w * 0.05; // 20 columns across

    // Vertical lines
    double x = 0;
    while (x < w) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
      x += spacing;
    }

    // Horizontal lines
    double y = 0;
    while (y < h) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      y += spacing;
    }
  }

  /// Three centered horizontal neon lines, each pulsing on its own phase.
  void _drawAccentLines(Canvas canvas, double w, double h) {
    // 3 horizontal neon-blue lines that pulse in opacity
    const List<double> lineYs = [
      0.3,
      0.5,
      0.7,
    ]; // line heights as fraction of h
    const Color neonBlue = Color(0xff6496ff);

    for (int i = 0; i < lineYs.length; i++) {
      // Pulse 0..1; progress*2pi*3 = 3 pulses per era, i*2.1 offsets each line.
      final double pulse = (sin((progress * 6.283 * 3) + i * 2.1) * 0.5 + 0.5);
      final double lineOpacity = (pulse * 0.3 * progress).clamp(0.0, 0.3);

      if (lineOpacity < 0.003) continue;

      final double ly = h * lineYs[i];
      final double lineWidth =
          w * (0.3 + 0.2 * pulse); // 30..50% width, widens on pulse
      final double lineX = (w - lineWidth) * 0.5; // centered

      // Glow
      final Paint glowPaint = Paint()
        ..color = neonBlue.withValues(alpha: lineOpacity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
        ..strokeWidth = 5;
      canvas.drawLine(
        Offset(lineX, ly),
        Offset(lineX + lineWidth, ly),
        glowPaint,
      );

      // Core line
      final Paint linePaint = Paint()
        ..color = neonBlue.withValues(alpha: lineOpacity)
        ..strokeWidth = 1.5;
      canvas.drawLine(
        Offset(lineX, ly),
        Offset(lineX + lineWidth, ly),
        linePaint,
      );
    }
  }

  /// Dot particles rising up the canvas, looping via the fractional part.
  void _drawDigitalParticles(Canvas canvas, double w, double h) {
    // Small dot particles drifting upward, digital/energy particles
    const int particleCount = 20;
    const Color particleColor = Color(0xff6496ff);

    for (int i = 0; i < particleCount; i++) {
      final double seed =
          (i * 137.508) % 100 / 100; // golden-angle scatter, 0..1
      final double px = w * ((seed * 7 + i * 0.13) % 1.0);
      final double rawY =
          ((seed * 5 + progress * 1.5 + i * 0.17) % 1.0); // 0..1 looping height
      final double py = h * (1.0 - rawY); // drift upward

      final double particleAlpha =
          (1.0 - rawY) * progress * 0.45; // brightest at the bottom
      if (particleAlpha < 0.01) continue;

      final bool isDark = lightProgress < 0.5;
      final Color pColor = isDark
          ? particleColor.withValues(alpha: particleAlpha)
          : AppColors.portfolioAccent.withValues(alpha: particleAlpha * 0.6);

      // Glow
      final Paint glowPaint = Paint()
        ..color = pColor.withValues(alpha: particleAlpha * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(px, py), 3, glowPaint);

      // Core dot
      final Paint dotPaint = Paint()..color = pColor;
      canvas.drawCircle(Offset(px, py), 1.5, dotPaint);
    }
  }

  /// Repaint when scroll progress or background brightness changes.
  @override
  bool shouldRepaint(covariant FutureTechPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      lightProgress != oldDelegate.lightProgress;
}
