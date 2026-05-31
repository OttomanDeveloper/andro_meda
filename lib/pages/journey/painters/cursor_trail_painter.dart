import 'package:safeandromeda/core/hooks/hooks.dart';

/// Draws a small wobbling comet trail of dots that follows the mouse.
class CursorTrailPainter extends CustomPainter {
  CursorTrailPainter({required this.position, required this.time});

  final Offset position; // last hover point in global coords
  final double time; // global clock in seconds, drives the wobble

  /// Lays down 6 dots offset by phase-shifted sine/cosine around [position].
  @override
  void paint(Canvas canvas, Size size) {
    // No mouse has moved yet (or this is a touch device), skip the trail so
    // it doesn't sit as a stray dot in the top-left corner.
    if (position == Offset.zero) return;

    final Paint paint = Paint();
    for (int i = 0; i < 6; i++) {
      // Each dot wobbles wider and slower the further it is down the trail.
      final double offsetX = sin(time * 3 + i) * (3 + i * 2);
      final double offsetY = cos(time * 2.5 + i * 0.7) * (2 + i * 1.5);
      final double alpha = (0.4 - i * 0.06).clamp(
        0.0,
        0.4,
      ); // fade toward the tail
      final double radius = 2.0 - i * 0.2; // shrink toward the tail

      // Sharp core dot.
      paint.color = const Color(0xffffffff).withValues(alpha: alpha);
      paint.maskFilter = null;
      canvas.drawCircle(
        Offset(position.dx + offsetX, position.dy + offsetY),
        radius,
        paint,
      );

      // Soft glow: 3x radius, dimmer, blurred.
      paint.color = const Color(0xffffffff).withValues(alpha: alpha * 0.3);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(
        Offset(position.dx + offsetX, position.dy + offsetY),
        radius * 3,
        paint,
      );
      paint.maskFilter = null;
    }
  }

  /// Always repaint: the trail animates every frame off [time].
  @override
  bool shouldRepaint(covariant CursorTrailPainter old) => true;
}
