import 'package:safeandromeda/core/hooks/hooks.dart';

/// Pterosaurs gliding low among the forest, larger and closer than the distant
/// flock, flapping their long membranous wings.
class ForestFliersPainter extends CustomPainter {
  const ForestFliersPainter({required this.progress, required this.time});
  final double progress; // era scroll progress 0..1
  final double time; // global animation clock, seconds

  static const Color _silhouette = Color(0xff0a1508); // near-black flier fill

  /// Flies three low pterosaurs across the mid-scene, each flapping and bobbing.
  @override
  void paint(Canvas canvas, Size size) {
    // Ramp 0..1 over progress 0.14..0.34.
    final double appear = ((progress - 0.14) / 0.2).clamp(0.0, 1.0);
    if (appear <= 0) return;

    final double w = size.width;
    for (int i = 0; i < 3; i++) {
      final double speed = 0.05 + i * 0.022; // later fliers move faster
      final double dir = i.isEven ? 1.0 : -1.0; // alternate flight direction
      final double t =
          (time * speed + i * 0.45) % 1.35 - 0.18; // wrap across width
      final double x = (dir > 0 ? t : 1.0 - t) * w; // flip path for left-fliers
      final double y =
          size.height *
              (0.55 + i * 0.05) + // mid-scene height, lower each flier
          sin(time * 0.8 + i * 2) *
              size.height *
              0.03; // 3%-height vertical bob
      final double span = 56.0 + i * 16; // wingspan, px
      final double flap = sin(time * 3.2 + i); // -1..1 wing-beat phase

      canvas.save();
      canvas.translate(x, y);
      canvas.scale(dir, 1.0); // mirror to face flight direction
      _pterosaur(
        canvas,
        span,
        flap,
        _silhouette.withValues(alpha: 0.6 * appear),
      );
      canvas.restore();
    }
  }

  /// One pterosaur centred at the origin: two membranous wings raised by
  /// [flap], a slim body, and a beak with a head crest.
  void _pterosaur(Canvas canvas, double span, double flap, Color col) {
    final Paint fill = Paint()..color = col;
    final double up = flap * span * 0.22; // wingtip lift, scales with span

    // Long membranous wings that flap.
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(-span * 0.5, -up - 4, -span, -up * 0.4)
        ..lineTo(-span * 0.7, 4)
        ..quadraticBezierTo(-span * 0.3, 6, 0, 3)
        ..close(),
      fill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(span * 0.5, -up - 4, span, -up * 0.4)
        ..lineTo(span * 0.7, 4)
        ..quadraticBezierTo(span * 0.3, 6, 0, 3)
        ..close(),
      fill,
    );

    // Body.
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: span * 0.18, height: 6),
      fill,
    );

    // Beak and head crest (Pteranodon-style).
    final Paint stroke = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(span * 0.06, -1)
        ..lineTo(span * 0.28, -3),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(span * 0.08, -2)
        ..lineTo(0, -8),
      stroke,
    );
  }

  /// Repaint whenever scroll or the animation clock moves.
  @override
  bool shouldRepaint(covariant ForestFliersPainter old) =>
      old.time != time || old.progress != progress;
}
