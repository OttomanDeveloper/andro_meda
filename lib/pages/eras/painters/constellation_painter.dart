import 'package:safeandromeda/core/hooks/hooks.dart';

/// Three constellations whose connecting lines draw themselves in as the
/// First Stars era progresses, with a bright dot at every star point.
class ConstellationPainter extends CustomPainter {
  const ConstellationPainter({required this.progress, required this.time});

  /// First Stars era scroll progress, 0..1; drives the line-draw reveal.
  final double progress;

  /// Global animation clock in seconds (unused; reveal is scroll-driven).
  final double time;

  // Star-point chains traced as the constellations appear.
  // Each point is [x, y] as a fraction of width/height.
  static const List<List<List<double>>> _constellations = [
    // Triangle
    [
      [0.2, 0.25],
      [0.28, 0.15],
      [0.35, 0.28],
    ],
    // Chain
    [
      [0.55, 0.2],
      [0.62, 0.25],
      [0.68, 0.18],
      [0.75, 0.22],
    ],
    // Arc
    [
      [0.4, 0.6],
      [0.48, 0.55],
      [0.56, 0.58],
    ],
  ];

  /// Traces each constellation's lines and dots based on scroll progress.
  @override
  void paint(Canvas canvas, Size size) {
    // Constellations appear only past the first third of the era.
    if (progress < 0.3) return;
    // Lines fade in over the next quarter of scroll, capping at 0.65 alpha.
    final double lineOpacity = ((progress - 0.3) / 0.25).clamp(0.0, 0.65);
    final Paint linePaint = Paint()
      ..color = const Color(0xffc8dcff).withValues(alpha: lineOpacity)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    for (final List<List<double>> constellation in _constellations) {
      final Path path = Path();
      for (int i = 0; i < constellation.length; i++) {
        // Per-segment 0..1 draw; later points start later (i * 0.03 stagger).
        final double drawProgress = ((progress - 0.3 - i * 0.03) / 0.2).clamp(
          0.0,
          1.0,
        );
        // This and the following segments have not started yet.
        if (drawProgress <= 0) break;

        final double cx = constellation[i][0] * size.width;
        final double cy = constellation[i][1] * size.height;

        if (i == 0) {
          path.moveTo(cx, cy);
        } else {
          // Line end interpolates from previous star toward this one, so the
          // segment visibly grows out as drawProgress climbs to 1.
          final double prevX = constellation[i - 1][0] * size.width;
          final double prevY = constellation[i - 1][1] * size.height;
          final double x = prevX + (cx - prevX) * drawProgress;
          final double y = prevY + (cy - prevY) * drawProgress;
          path.lineTo(x, y);
        }

        // Bright dot at each star point (3x line alpha so stars read first).
        canvas.drawCircle(
          Offset(cx, cy),
          2.5,
          Paint()
            ..color = const Color(
              0xffc8dcff,
            ).withValues(alpha: lineOpacity * 3),
        );
      }
      canvas.drawPath(path, linePaint);
    }
  }

  /// Repaints when scroll changes; the line-draw reveal tracks progress.
  @override
  bool shouldRepaint(covariant ConstellationPainter old) =>
      old.progress != progress || old.time != time;
}
