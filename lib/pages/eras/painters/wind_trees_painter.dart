import 'package:safeandromeda/core/hooks/hooks.dart';

/// Large foreground trees framing the scene, their trunks, branches and leafy
/// canopies swaying gently in a gusty wind.
class WindTreesPainter extends CustomPainter {
  const WindTreesPainter({required this.progress, required this.time});
  final double progress; // era scroll progress 0..1
  final double time; // global animation clock, seconds

  static const Color _foliage = Color(0xff081207); // near-black tree fill
  // Trunk x as fractions of width: two trees per side, framing the scene.
  static const List<double> _positions = [0.05, 0.19, 0.82, 0.95];

  /// Computes a shared wind value, then draws each framing tree swaying.
  @override
  void paint(Canvas canvas, Size size) {
    // Ramp 0..1 over progress 0.1..0.3; trees are among the first to appear.
    final double appear = ((progress - 0.1) / 0.2).clamp(0.0, 1.0);
    if (appear <= 0) return;

    final double w = size.width;
    final double groundY = size.height * 0.78; // trunk base line
    // Gusty wind: a slow base sway with a faster flutter on top.
    final double wind = sin(time * 0.8) * 0.6 + sin(time * 2.0) * 0.25;

    for (int i = 0; i < _positions.length; i++) {
      _tree(
        canvas,
        _positions[i] * w,
        groundY,
        130.0 + i * 14,
        wind,
        i,
        appear,
      );
    }
  }

  /// One tree at base x [bx], height [h]: curved trunk, three branches and a
  /// blobby canopy, all offset by [sway]. [a] is the fade-in alpha.
  void _tree(
    Canvas canvas,
    double bx,
    double groundY,
    double h,
    double wind,
    int i,
    double a,
  ) {
    final double sway =
        wind + sin(time * 1.3 + i) * 0.3; // shared wind + per-tree phase
    final double topX =
        bx + sway * 16; // trunk top leans up to 16px with the gust
    final double topY = groundY - h;

    // Trunk, curving with the wind toward the top.
    final Paint bark = Paint()..color = _foliage.withValues(alpha: 0.9 * a);
    canvas.drawPath(
      Path()
        ..moveTo(bx - 6, groundY)
        ..lineTo(bx + 6, groundY)
        ..quadraticBezierTo(
          bx + 4 + sway * 7,
          groundY - h * 0.6,
          topX + 4,
          topY,
        )
        ..quadraticBezierTo(
          bx - 4 + sway * 7,
          groundY - h * 0.6,
          bx - 6,
          groundY,
        )
        ..close(),
      bark,
    );

    // A few branches reaching out, swaying with the gust.
    final Paint branch = Paint()
      ..color = _foliage.withValues(alpha: 0.85 * a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    for (int b = 0; b < 3; b++) {
      final double by =
          groundY - h * (0.55 + b * 0.15); // attach point, higher each branch
      final double side = b.isEven ? 1.0 : -1.0; // alternate left/right
      final double bx0 = bx + sway * (8 + b * 4); // higher branches sway more
      canvas.drawPath(
        Path()
          ..moveTo(bx0, by)
          ..quadraticBezierTo(
            bx0 + side * h * 0.18,
            by - h * 0.04 + sway * 8,
            bx0 + side * h * 0.32,
            by - h * 0.12 + sway * 14,
          ),
        branch,
      );
    }

    // Leafy canopy: overlapping blobs offset by the wind, denser near the top.
    final Paint leaf = Paint()..color = _foliage.withValues(alpha: 0.82 * a);
    final Random r = Random(i + 11); // per-tree stable blob layout
    for (int c = 0; c < 9; c++) {
      final double ct = c / 8.0; // 0..1 across the blob set
      final double cx =
          topX +
          (r.nextDouble() - 0.5) * h * 0.55 +
          sway * (8 + ct * 14); // spread + wind drift
      final double cy =
          topY +
          (r.nextDouble() - 0.2) * h * 0.32; // mostly above the trunk top
      final double cr =
          h * (0.16 + r.nextDouble() * 0.12); // blob radius scales with tree
      canvas.drawCircle(Offset(cx, cy), cr, leaf);
    }
  }

  /// Repaint whenever scroll or the animation clock moves.
  @override
  bool shouldRepaint(covariant WindTreesPainter old) =>
      old.time != time || old.progress != progress;
}
