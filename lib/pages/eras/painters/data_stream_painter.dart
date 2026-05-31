import 'package:safeandromeda/core/hooks/hooks.dart';

/// Matrix-style falling data: 20 columns of dots and dashes scrolling upward
/// and wrapping, each column at its own speed.
class DataStreamPainter extends CustomPainter {
  const DataStreamPainter({required this.progress, required this.time});

  /// Era scroll progress, 0..1; gates and fades the stream.
  final double progress;

  /// Global animation clock in seconds; scrolls the dots.
  final double time;

  /// Lays out the column/dot grid and wraps each dot's Y as it scrolls off top.
  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.1) return;
    final double streamOpacity = ((progress - 0.1) / 0.4).clamp(
      0.0,
      0.225,
    ); // capped faint fade-in
    final Paint paint = Paint();
    final Random r = Random(77); // fixed seed keeps the pattern stable

    for (int col = 0; col < 20; col++) {
      final double x =
          (col / 20) * size.width + r.nextDouble() * 20; // column x + jitter
      final double speed =
          0.5 + r.nextDouble() * 1.5; // per-column scroll speed

      for (int dot = 0; dot < 20; dot++) {
        final double baseY =
            size.height -
            (dot * size.height * 0.05); // dots spaced 5% apart, bottom-up
        final double y =
            baseY -
            ((time * speed * 30) % size.height); // scroll up, wrap each cycle
        final double wrappedY = y < 0 ? y + size.height : y; // keep on-canvas

        final double dotSize = 1.5 + r.nextDouble() * 3;
        final bool isDash = r.nextDouble() > 0.6; // ~40% drawn as dashes

        paint.color = AppColors.futureGlow.withValues(
          alpha: streamOpacity * (0.5 + r.nextDouble() * 0.5),
        );

        if (isDash) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, wrappedY, dotSize, dotSize * 4),
              const Radius.circular(1),
            ),
            paint,
          );
        } else {
          canvas.drawCircle(Offset(x, wrappedY), dotSize * 0.5, paint);
        }
      }
    }
  }

  /// Repaint when scroll progress or the clock changes.
  @override
  bool shouldRepaint(covariant DataStreamPainter old) =>
      old.progress != progress || old.time != time;
}
