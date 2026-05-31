import 'package:safeandromeda/core/hooks/hooks.dart';

/// Dinosaurs ambling across the horizon: a long-necked sauropod, a T-Rex and a
/// Triceratops, each with animated walking legs.
class DinosPainter extends CustomPainter {
  const DinosPainter({required this.progress, required this.time});
  final double progress; // era scroll progress 0..1
  final double time; // global animation clock, seconds

  static const Color _silhouette = Color(0xff0a1508); // near-black dino fill

  /// Fades in the three dinos once scroll passes ~0.12, then walks them.
  @override
  void paint(Canvas canvas, Size size) {
    // Ramp 0..1 over progress 0.12..0.32; dinos arrive after the trees.
    final double appear = ((progress - 0.12) / 0.2).clamp(0.0, 1.0);
    if (appear <= 0) return;
    final double groundY = size.height * 0.72; // shared ground line for feet
    for (int idx = 0; idx < 3; idx++) {
      _walker(canvas, size.width, groundY, appear, idx);
    }
  }

  /// Positions one dino by index: picks species, walk direction, speed and
  /// scale, then draws it at its current x on the ground line.
  void _walker(
    Canvas canvas,
    double w,
    double groundY,
    double appear,
    int idx,
  ) {
    final Random r = Random(idx + 40); // per-dino stable start offset
    final double speed = 0.012 + idx * 0.005; // later dinos walk a touch faster
    final double dir = idx.isEven ? 1.0 : -1.0; // alternate facing left/right
    final double t =
        (time * speed + r.nextDouble()) % 1.3 - 0.15; // wrap across screen
    final double x = (dir > 0 ? t : 1.0 - t) * w; // flip path for left-walkers
    final double scale = idx == 0
        ? 1.2
        : (idx == 1 ? 1.0 : 0.85); // sauropod biggest
    final double walk = time * (2.0 + idx * 0.6); // leg-cycle phase, radians
    final Color col = _silhouette.withValues(
      alpha: (idx == 0 ? 0.72 : 0.66) * appear, // sauropod slightly more opaque
    );

    canvas.save();
    canvas.translate(x, groundY);
    canvas.scale(dir * scale, scale); // negative x mirrors the whole dino
    if (idx == 0) {
      _sauropod(canvas, walk, col);
    } else if (idx == 1) {
      _trex(canvas, walk, col);
    } else {
      _triceratops(canvas, walk, col);
    }
    canvas.restore();
  }

  /// One straight quadruped leg from hip to foot; [phase] drives the step so
  /// the foot swings fore/aft and lifts on the forward half of the cycle.
  void _leg(Canvas canvas, double hipX, double hipY, double phase, Paint limb) {
    final double foot = sin(phase) * 7; // horizontal foot swing, px
    final double lift =
        max(0.0, cos(phase)) * 5; // foot off ground only when cos>0
    canvas.drawPath(
      Path()
        ..moveTo(hipX, -hipY)
        ..lineTo(hipX + foot, -lift),
      limb,
    );
  }

  /// Long-necked sauropod: four legs in a diagonal gait, barrel body, raised
  /// neck to a small head, and a long sweeping tail.
  void _sauropod(Canvas canvas, double walk, Color col) {
    final Paint fill = Paint()..color = col;
    final Paint limb = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    const double bodyH = 36; // body centre height above ground
    const double hipY = 22; // hip height above ground

    // Far pair of legs, drawn before the body so the body overlaps them.
    _leg(canvas, -24, hipY, walk, limb);
    _leg(canvas, 14, hipY, walk + pi, limb); // opposite phase = diagonal gait

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-4, -bodyH), width: 96, height: 36),
      fill,
    );

    // Near pair of legs, quarter-cycle offset from the far pair.
    _leg(canvas, -14, hipY, walk + pi * 0.5, limb);
    _leg(canvas, 26, hipY, walk + pi * 1.5, limb);

    // Long graceful neck up to a small head.
    final Paint neck = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(36, -bodyH - 2)
        ..quadraticBezierTo(62, -bodyH - 34, 78, -bodyH - 64),
      neck,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(81, -bodyH - 66),
        width: 16,
        height: 9,
      ),
      fill,
    );

    // Long tapering tail.
    final Paint tail = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(-42, -bodyH)
        ..quadraticBezierTo(-82, -bodyH - 2, -112, -bodyH + 16),
      tail,
    );
  }

  /// Tyrannosaurus: hunched torso, big jawed head, tiny arms, thick tail.
  void _trex(Canvas canvas, double walk, Color col) {
    final Paint fill = Paint()..color = col;
    final Paint limb = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Far hind leg.
    _theroLeg(canvas, -4, 30, walk + pi, limb, 1.0);

    // Thick counterbalancing tail.
    final Paint tail = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(-18, -36)
        ..quadraticBezierTo(-55, -40, -92, -24),
      tail,
    );

    // Hunched torso.
    canvas.drawPath(
      Path()
        ..moveTo(-22, -34)
        ..quadraticBezierTo(-6, -54, 22, -50)
        ..quadraticBezierTo(38, -47, 44, -40)
        ..lineTo(40, -24)
        ..quadraticBezierTo(8, -14, -18, -22)
        ..close(),
      fill,
    );

    // Near hind leg.
    _theroLeg(canvas, 8, 30, walk, limb, 1.0);

    // Tiny arm.
    canvas.drawPath(
      Path()
        ..moveTo(34, -30)
        ..lineTo(42, -24)
        ..lineTo(40, -19),
      limb,
    );

    // Short thick neck.
    final Paint neck = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(40, -44)
        ..quadraticBezierTo(52, -52, 60, -52),
      neck,
    );

    // Big head: upper jaw then lower jaw, leaving a mouth gap.
    canvas.drawPath(
      Path()
        ..moveTo(54, -56)
        ..lineTo(86, -52)
        ..lineTo(86, -45)
        ..lineTo(60, -45)
        ..close(),
      fill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(60, -43)
        ..lineTo(82, -42)
        ..lineTo(58, -39)
        ..close(),
      fill,
    );
  }

  /// Triceratops: bulky quadruped with a bony frill, beak and horns.
  void _triceratops(Canvas canvas, double walk, Color col) {
    final Paint fill = Paint()..color = col;
    final Paint limb = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    const double bodyH = 26; // body centre height above ground
    const double hipY = 22; // hip height above ground

    // Far pair of legs first; opposite phases give the diagonal gait.
    _leg(canvas, -18, hipY, walk, limb);
    _leg(canvas, 10, hipY, walk + pi, limb);

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-4, -bodyH), width: 64, height: 34),
      fill,
    );

    // Near pair, quarter-cycle offset from the far pair.
    _leg(canvas, -10, hipY, walk + pi * 0.5, limb);
    _leg(canvas, 20, hipY, walk + pi * 1.5, limb);

    // Short tail.
    final Paint tail = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(-30, -bodyH)
        ..quadraticBezierTo(-48, -bodyH + 2, -58, -bodyH + 12),
      tail,
    );

    // Bony frill rising behind the head.
    canvas.drawPath(
      Path()
        ..moveTo(20, -bodyH - 6)
        ..quadraticBezierTo(34, -bodyH - 30, 44, -bodyH - 8)
        ..quadraticBezierTo(40, -bodyH + 6, 24, -bodyH + 2)
        ..close(),
      fill,
    );

    // Head + beak.
    canvas.drawPath(
      Path()
        ..moveTo(34, -bodyH - 6)
        ..lineTo(54, -bodyH - 2)
        ..lineTo(56, -bodyH + 4)
        ..lineTo(40, -bodyH + 8)
        ..close(),
      fill,
    );

    // Brow horn and nose horn.
    final Paint horn = Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(40, -bodyH - 4)
        ..lineTo(58, -bodyH - 15),
      horn,
    );
    canvas.drawPath(
      Path()
        ..moveTo(48, -bodyH)
        ..lineTo(55, -bodyH - 9),
      horn,
    );
  }

  /// Bent two-segment theropod (T-Rex) leg: hip to a mid knee to the foot.
  /// [phase] drives the stride, [sc] scales swing and lift together.
  void _theroLeg(
    Canvas canvas,
    double hipX,
    double hipY,
    double phase,
    Paint limb,
    double sc,
  ) {
    final double swing = sin(phase) * 9 * sc; // foot fore/aft travel, px
    final double lift =
        max(0.0, cos(phase)) * 7 * sc; // foot lift on forward swing
    canvas.drawPath(
      Path()
        ..moveTo(hipX, -hipY)
        ..lineTo(hipX + swing * 0.5 + 4 * sc, -hipY * 0.5 - lift * 0.3)
        ..lineTo(hipX + swing, -lift),
      limb,
    );
  }

  /// Repaint whenever scroll or the animation clock moves.
  @override
  bool shouldRepaint(covariant DinosPainter old) =>
      old.time != time || old.progress != progress;
}
