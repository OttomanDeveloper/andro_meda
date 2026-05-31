import 'package:safeandromeda/core/hooks/hooks.dart';

/// A single floating epoch annotation: [label] text anchored at ([x], [y]) as
/// fractions of the painter's canvas, fading in at scroll [appearAt].
class InfoLabel {
  const InfoLabel(this.label, this.x, this.y, this.appearAt);

  final String label;
  final double x;
  final double y;
  final double appearAt;
}

/// Draws the floating epoch annotations shared across eras.
///
/// Each label fades in at its own scroll point, lingers, then fades away with a
/// gentle [time] pulse. A leading pointer line and dot plus a dark backing
/// shadow keep the white text legible against any background. [glowColor] tints
/// the marker and the text's outer glow to match the era's palette.
///
/// Positions hug the dark periphery (x near the edges, away from the central
/// column) and y is a fraction of the full (2x viewport) era canvas.
class InfoLabelPainter extends CustomPainter {
  const InfoLabelPainter({
    required this.progress,
    required this.time,
    required this.labels,
    required this.glowColor,
  });

  /// Current era scroll progress in [0, 1]; gates each label's fade timing.
  final double progress;

  /// Global animation clock in seconds; drives the opacity pulse.
  final double time;

  /// Annotations to draw, each with its own position and appear point.
  final List<InfoLabel> labels;

  /// Tint for the marker and the text's outer glow.
  final Color glowColor;

  /// Draws every visible label with its marker, fade, and pulse.
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < labels.length; i++) {
      final InfoLabel fact = labels[i];

      // Fade in over 12% of scroll past the label's appearAt point.
      final double appear = ((progress - fact.appearAt) / 0.12).clamp(0.0, 1.0);
      if (appear <= 0) continue;
      // Fade out over 18% of scroll, starting 36% after appearAt.
      final double fadeOut = (1.0 - (progress - fact.appearAt - 0.36) / 0.18)
          .clamp(0.0, 1.0);
      final double pulse =
          0.85 + 0.15 * sin(time * 1.2 + i); // gentle breathing
      final double alpha = appear * fadeOut * pulse;
      if (alpha <= 0.01) continue;

      final Offset pos = Offset(fact.x * size.width, fact.y * size.height);

      final Paint marker = Paint()
        ..color = glowColor.withValues(alpha: alpha)
        ..strokeWidth = 1.2;

      final TextPainter label = TextPainter(
        text: TextSpan(
          text: fact.label,
          style: TextStyle(
            color: AppColors.white.withValues(
              alpha: (alpha * 0.95).clamp(0.0, 1.0),
            ),
            fontSize: 13,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
            shadows: [
              // Dark backing keeps text readable where the background brightens.
              Shadow(
                color: AppColors.black.withValues(alpha: alpha),
                blurRadius: 4,
              ),
              Shadow(color: glowColor.withValues(alpha: alpha), blurRadius: 12),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // If the label would run off the right edge (narrow phones), flip it so
      // the marker points the other way and the text sits to the left.
      final bool flip = pos.dx + 22 + label.width > size.width - 4;
      if (flip) {
        canvas.drawLine(pos, pos - const Offset(16, 0), marker);
        canvas.drawCircle(pos, 2.4, marker);
        label.paint(canvas, Offset(pos.dx - 22 - label.width, pos.dy - 7));
      } else {
        // Leading marker, a short pointer line and dot, annotation style.
        canvas.drawLine(pos, pos + const Offset(16, 0), marker);
        canvas.drawCircle(pos, 2.4, marker);
        label.paint(canvas, pos + const Offset(22, -7));
      }
    }
  }

  /// Repaints when scroll, clock, label set, or tint changes.
  @override
  bool shouldRepaint(covariant InfoLabelPainter old) =>
      old.progress != progress ||
      old.time != time ||
      old.labels != labels ||
      old.glowColor != glowColor;
}
