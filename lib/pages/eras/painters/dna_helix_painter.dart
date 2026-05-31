import 'package:safeandromeda/core/hooks/hooks.dart';

/// A faint rotating DNA double helix: two sine strands 180° apart with rungs
/// linking them, sitting on the right side of the canvas.
class DNAHelixPainter extends CustomPainter {
  const DNAHelixPainter({required this.progress, required this.time});

  /// Era scroll progress, 0..1; gates and fades the helix.
  final double progress;

  /// Global animation clock in seconds; spins the helix.
  final double time;

  /// Builds the two strand paths point by point and draws rungs between them.
  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.2) return;
    final double helixOpacity = ((progress - 0.2) / 0.3).clamp(
      0.0,
      0.4,
    ); // capped faint fade-in
    final Paint strandPaint = Paint()
      ..color = AppColors.lifeGreen.withValues(alpha: helixOpacity)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    final Paint rungPaint = Paint()
      ..color = AppColors.lifeTeal.withValues(alpha: helixOpacity * 0.8)
      ..strokeWidth = 0.8;

    final double centerX = size.width * 0.7; // helix axis, right of center
    final double startY = size.height * 0.15; // top of helix
    final double endY = size.height * 0.85; // bottom of helix
    final double amplitude = size.width * 0.06; // strand swing from axis
    const int points = 60; // samples down the helix

    final Path strand1 = Path();
    final Path strand2 = Path();

    for (int i = 0; i <= points; i++) {
      final double t = i / points; // 0 at top, 1 at bottom
      final double y = startY + (endY - startY) * t;
      final double phase =
          t * pi * 6 + time * 1.5; // 3 full twists; time spins it

      final double x1 = centerX + sin(phase) * amplitude;
      final double x2 =
          centerX - sin(phase) * amplitude; // opposite strand, 180° out

      if (i == 0) {
        strand1.moveTo(x1, y);
        strand2.moveTo(x2, y);
      } else {
        strand1.lineTo(x1, y);
        strand2.lineTo(x2, y);
      }

      // Rungs connecting the two strands every 4 points
      if (i % 4 == 0 && i > 0) {
        canvas.drawLine(Offset(x1, y), Offset(x2, y), rungPaint);
      }
    }

    canvas.drawPath(strand1, strandPaint);
    canvas.drawPath(strand2, strandPaint);
  }

  /// Repaint when scroll progress or the clock changes.
  @override
  bool shouldRepaint(covariant DNAHelixPainter old) =>
      old.progress != progress || old.time != time;
}
