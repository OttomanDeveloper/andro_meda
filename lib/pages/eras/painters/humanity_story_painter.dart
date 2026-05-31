import 'package:safeandromeda/core/hooks/hooks.dart';

/// Single painter for the "Rise of Humanity" era: three scroll-revealed acts
/// (Ice Age, Forest, Camp/City), each anchored to its own ground line.
class HumanityStoryPainter extends CustomPainter {
  /// [progress] is era scroll 0..1, [time] the global clock in seconds,
  /// [viewportHeight] the device viewport (canvas is 2x this tall).
  const HumanityStoryPainter({
    required this.progress,
    required this.time,
    required this.viewportHeight,
  });

  final double progress; // era scroll 0..1, drives act cross-fades
  final double time; // global animation clock, seconds
  final double viewportHeight; // device viewport height (vp)

  static const Color _dark = Color(0xff0d0600); // near-black silhouette fill
  static const Color _ivory = Color(0xffe8d8b0); // tusks, spears, fangs
  static const Color _snowCol = Color(0xffdce8f2); // snow caps and flakes
  static const Color _ice = Color(0xff9fb8d8); // cold blue, distant ranges
  static const Color _coldBody = Color(0xff34404f); // far mammoths in haze
  static const Color _canopy = Color(0xff16300f); // dark back foliage
  static const Color _leaf = Color(0xff2f5a22); // lighter front leaves

  /// Computes per-act opacity windows from [progress] and draws whichever
  /// acts are currently visible.
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double vp = viewportHeight;

    // Ground lines as fractions of the full (2x viewport) era canvas.
    final double gyIce = size.height * 0.42; // act 1 horizon, upper canvas
    final double gyForest = size.height * 0.70; // act 2 floor, mid canvas
    final double gyCamp = size.height * 0.96; // act 3 ground, near bottom

    // Ice fades out by progress 0.40. Forest fades in 0.12..0.30 and out
    // 0.48..0.66 (product of two ramps). Camp fades in 0.45..0.63.
    final double iceOp = ((0.40 - progress) / 0.20).clamp(0.0, 1.0);
    final double forestOp =
        ((progress - 0.12) / 0.18).clamp(0.0, 1.0) *
        ((0.66 - progress) / 0.18).clamp(0.0, 1.0);
    final double campOp = ((progress - 0.45) / 0.18).clamp(0.0, 1.0);

    if (iceOp > 0.01) _drawIceAge(canvas, w, vp, gyIce, iceOp);
    if (forestOp > 0.01) _drawForest(canvas, w, vp, gyForest, forestOp);
    if (campOp > 0.01) _drawCamp(canvas, w, vp, gyCamp, campOp);
  }

  /// Fills a silhouette path and optionally strokes a warm fire-lit rim.
  // Dark silhouette fill with an optional warm fire-lit rim.
  void _fill(Canvas c, Path p, double op, {Color? color, double rim = 0.0}) {
    c.drawPath(
      p,
      Paint()..color = (color ?? _dark).withValues(alpha: 0.92 * op),
    );
    if (rim > 0) {
      c.drawPath(
        p,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..color = AppColors.humanityFire.withValues(alpha: rim * op)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }
  }

  // ===========================================================================
  // ACT 1, ICE AGE: snow peaks, a mammoth herd, and a hunt.
  // ===========================================================================
  /// Act 1: snow gradient, peaks, a receding mammoth herd, and a hunt.
  void _drawIceAge(Canvas c, double w, double vp, double gy, double op) {
    // Cold snow field below the horizon.
    c.drawRect(
      Rect.fromLTWH(0, gy, w, vp * 0.5),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _ice.withValues(alpha: 0.16 * op),
            _ice.withValues(alpha: 0.02 * op),
          ],
        ).createShader(Rect.fromLTWH(0, gy, w, vp * 0.5)),
    );

    _snowMountains(c, w, vp, gy, op);

    // The herd recedes into the distance: small, pale and high; large, dark
    // and near. The nearest one is the quarry.
    _mammoth(
      c,
      w * 0.27,
      gy - vp * 0.05,
      w * 0.00060,
      op * 0.45,
      _coldBody,
      fringe: false,
    );
    _mammoth(
      c,
      w * 0.42,
      gy - vp * 0.035,
      w * 0.00072,
      op * 0.6,
      _coldBody,
      fringe: false,
    );
    _mammoth(c, w * 0.58, gy - vp * 0.02, w * 0.00090, op * 0.78, _ice);
    _mammoth(c, w * 0.84, gy, w * 0.00120, op, _dark);

    // Hunters closing on the near mammoth, spears in the air.
    _hunters(c, w, vp, gy, op, const [0.66, 0.695, 0.73]);
    _flyingSpears(c, w, vp, gy, op, 0.745, 0.05);

    _snow(c, w, vp, gy, op);
  }

  /// Draws two depth layers of jagged snow peaks with caps on the near range.
  void _snowMountains(Canvas c, double w, double vp, double gy, double op) {
    for (int layer = 0; layer < 2; layer++) {
      final double base = gy + 1;
      final double maxH = vp * (0.22 - layer * 0.07); // near range is taller

      final Color body = layer == 0
          ? _ice.withValues(alpha: 0.20 * op)
          : _snowCol.withValues(alpha: 0.14 * op);
      final int peaks = 4 + layer * 3; // back layer has more, smaller peaks
      final double seg = w / peaks; // horizontal slot per peak
      final Random r = Random(layer * 7 + 3); // fixed seed: stable silhouette

      final Path range = Path()..moveTo(0, base);
      final List<Offset> summits = [];
      for (int i = 0; i < peaks; i++) {
        final double px = (i + 0.5) * seg; // summit at slot centre
        final double py =
            base - maxH * (0.55 + r.nextDouble() * 0.45); // 55..100% of maxH
        summits.add(Offset(px, py));
        range.lineTo(px, py);
        range.lineTo((i + 1) * seg, base - maxH * 0.12 * r.nextDouble());
      }
      range
        ..lineTo(w, base)
        ..close();
      c.drawPath(range, Paint()..color = body);

      // Snow caps on the near range.
      if (layer == 0) {
        for (final Offset s in summits) {
          final Path cap = Path()
            ..moveTo(s.dx, s.dy)
            ..lineTo(s.dx - seg * 0.16, s.dy + maxH * 0.14)
            ..lineTo(s.dx + seg * 0.16, s.dy + maxH * 0.14)
            ..close();
          c.drawPath(
            cap,
            Paint()..color = _snowCol.withValues(alpha: 0.28 * op),
          );
        }
      }
    }
  }

  /// 70 falling, drifting snowflakes over the ice scene.
  void _snow(Canvas c, double w, double vp, double gy, double op) {
    final Paint p = Paint();
    final double top = gy - vp * 0.42; // flakes start above the horizon
    final Random r = Random(91);
    for (int i = 0; i < 70; i++) {
      final double sx0 = r.nextDouble(); // base x as a fraction of w
      final double speed = 0.4 + r.nextDouble() * 0.5; // fall rate
      final double yPhase =
          (time * speed + r.nextDouble() * 5) % 1.0; // 0..1 fall
      final double y = top + yPhase * (vp * 0.6);
      final double x =
          (sx0 + sin(time * 0.5 + i) * 0.02) * w +
          sin(time * speed + i) * w * 0.01; // gentle lateral drift
      final double rad = 1.0 + r.nextDouble() * 1.6;
      p.color = _snowCol.withValues(
        alpha: (0.5 - yPhase * 0.3) * op,
      ); // fade as it falls
      c.drawCircle(Offset(x % w, y), rad, p);
    }
  }

  // ===========================================================================
  // ACT 2, FOREST: a deer, a stalking band, and a sabertooth ambush.
  // ===========================================================================
  /// Act 2: forest floor, layered trees, grazing deer, stalkers, saber ambush.
  void _drawForest(Canvas c, double w, double vp, double gy, double op) {
    // Mossy forest floor.
    c.drawRect(
      Rect.fromLTWH(0, gy, w, vp * 0.5),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _canopy.withValues(alpha: 0.55 * op),
            AppColors.humanityBg.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, gy, w, vp * 0.5)),
    );

    // Back canopy haze and layered trees.
    _forest(c, w, vp, gy, op);

    // Prey grazing at the left.
    _deer(c, w * 0.18, gy, vp, w, op);

    // The band creeps in from the centre toward the prey.
    _stalkers(c, w, vp, gy, op);

    // The ambush: a sabertooth pounces from the right into the group.
    _leapingSaber(c, w, vp, gy, op);

    _leaves(c, w, vp, gy, op);
  }

  /// Three depth layers of tree trunks and canopy blobs swaying in wind.
  void _forest(Canvas c, double w, double vp, double gy, double op) {
    final Random r = Random(55); // fixed seed: stable tree placement
    // Three depth layers of foliage, darker and lower toward the front.
    for (int layer = 0; layer < 3; layer++) {
      final double bandY =
          gy - vp * (0.30 - layer * 0.10); // canopy line drops forward
      final Color foliage = Color.lerp(
        _leaf,
        _canopy,
        layer / 2.0,
      )!.withValues(alpha: (0.30 + layer * 0.22) * op);
      final int count = 8 - layer;
      for (int i = 0; i < count; i++) {
        final double tx = (i / count + r.nextDouble() * 0.05) * w; // tree x
        final double sway =
            sin(time * 0.7 + i + layer) * w * 0.004; // wind offset
        final double rad =
            vp *
            (0.05 + layer * 0.03) *
            (0.8 + r.nextDouble()); // canopy radius, bigger up front
        // Trunk for the nearer layers.
        if (layer >= 1) {
          c.drawRect(
            Rect.fromLTWH(tx - w * 0.006, bandY, w * 0.012, gy - bandY),
            Paint()
              ..color = const Color(0xff120c06).withValues(alpha: 0.6 * op),
          );
        }
        // Canopy blob.
        c.drawCircle(
          Offset(tx + sway, bandY),
          rad,
          Paint()
            ..color = foliage
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, vp * 0.012),
        );
      }
    }
  }

  /// Grazing deer: body, four legs, neck, head that lifts and drops, antlers.
  void _deer(Canvas c, double dx, double gy, double vp, double w, double op) {
    final double h = vp * 0.075; // deer height unit
    final double graze = sin(time * 0.6) * 0.5 + 0.5; // 0..1 head lift
    final Paint body = Paint()..color = _dark.withValues(alpha: 0.9 * op);

    c.drawPath(
      Path()
        ..moveTo(dx + w * 0.032, gy - h * 0.58)
        ..cubicTo(
          dx + w * 0.038,
          gy - h * 0.72,
          dx,
          gy - h * 0.74,
          dx - w * 0.02,
          gy - h * 0.64,
        )
        ..cubicTo(
          dx - w * 0.03,
          gy - h * 0.52,
          dx - w * 0.012,
          gy - h * 0.46,
          dx + w * 0.018,
          gy - h * 0.46,
        )
        ..cubicTo(
          dx + w * 0.032,
          gy - h * 0.46,
          dx + w * 0.036,
          gy - h * 0.5,
          dx + w * 0.032,
          gy - h * 0.58,
        )
        ..close(),
      body,
    );

    final Paint leg = Paint()
      ..color = _dark.withValues(alpha: 0.9 * op)
      ..strokeWidth = w * 0.004
      ..strokeCap = StrokeCap.round;
    for (final double lx in <double>[-0.016, -0.004, 0.022, 0.032]) {
      c.drawLine(
        Offset(dx + w * lx, gy - h * 0.46),
        Offset(dx + w * lx, gy),
        leg,
      );
    }

    final double headX = dx - w * 0.032;
    final double headY =
        gy - h * (0.72 - graze * 0.42); // lower head when grazing
    c.drawLine(
      Offset(dx - w * 0.016, gy - h * 0.64),
      Offset(headX, headY),
      Paint()
        ..color = _dark.withValues(alpha: 0.9 * op)
        ..strokeWidth = w * 0.006
        ..strokeCap = StrokeCap.round,
    );
    c.drawCircle(Offset(headX, headY), h * 0.09, body);

    // Antlers.
    final Paint ant = Paint()
      ..color = _dark.withValues(alpha: 0.85 * op)
      ..strokeWidth = w * 0.0025
      ..strokeCap = StrokeCap.round;
    c.drawLine(
      Offset(headX, headY - h * 0.06),
      Offset(headX - w * 0.012, headY - h * 0.26),
      ant,
    );
    c.drawLine(
      Offset(headX - w * 0.006, headY - h * 0.16),
      Offset(headX - w * 0.02, headY - h * 0.22),
      ant,
    );
    c.drawLine(
      Offset(headX + w * 0.004, headY - h * 0.06),
      Offset(headX + w * 0.014, headY - h * 0.24),
      ant,
    );
  }

  /// Band of four crouched hunters creeping in from centre toward the deer.
  void _stalkers(Canvas c, double w, double vp, double gy, double op) {
    const List<double> xs = [0.40, 0.46, 0.52, 0.58]; // band x positions
    for (int i = 0; i < xs.length; i++) {
      final double creep =
          sin(time * 0.8 + i * 1.1) * w * 0.005; // staggered shuffle
      _crouchHuman(c, w * xs[i] + creep, gy, vp, w, op, i);
    }
  }

  /// One crouched hunter leaning forward, spear held low toward the prey.
  // A crouched hunter leaning forward, spear held low toward the prey (left).
  void _crouchHuman(
    Canvas c,
    double hx,
    double gy,
    double vp,
    double w,
    double op,
    int i,
  ) {
    final double fh = vp * 0.06; // crouched figure height
    final Paint body = Paint()
      ..color = _dark.withValues(alpha: 0.92 * op)
      ..style = PaintingStyle.stroke
      ..strokeWidth = vp * 0.007
      ..strokeCap = StrokeCap.round;

    final Offset hip = Offset(hx, gy - fh * 0.34); // low hip = crouch
    final Offset shoulder = Offset(
      hx - w * 0.012,
      gy - fh * 0.62,
    ); // leaned forward
    c.drawLine(hip, Offset(hx + w * 0.006, gy), body);
    c.drawLine(hip, Offset(hx - w * 0.008, gy), body);
    c.drawLine(hip, shoulder, body);
    c.drawCircle(
      Offset(shoulder.dx - w * 0.004, shoulder.dy - fh * 0.12),
      fh * 0.12,
      Paint()..color = _dark.withValues(alpha: 0.92 * op),
    );
    // Low spear toward the prey, each held at a slightly different angle so
    // the band doesn't read as one rail.
    final Paint spear = Paint()
      ..color = _ivory.withValues(alpha: 0.5 * op)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final double sy = gy - fh * (0.46 + i * 0.07); // per-figure spear height
    c.drawLine(
      Offset(hx + w * 0.012, sy),
      Offset(hx - w * 0.05, sy - fh * (0.05 + i * 0.04)), // varied tilt
      spear,
    );
  }

  /// Sabertooth pouncing left into the band: arcs in x and y over its cycle.
  void _leapingSaber(Canvas c, double w, double vp, double gy, double op) {
    final double leap = sin(time * 1.5) * 0.5 + 0.5; // pounce cycle
    final double sx = w * (0.72 - leap * 0.10); // lunges leftward
    final double sy =
        gy - vp * 0.015 - sin(leap * pi) * vp * 0.07; // arc apex mid-leap
    final double k = w * 0.00085; // unit-coord scale

    c.save();
    c.translate(sx, sy);
    c.rotate(-0.15 - leap * 0.2); // nose-down tilt deepens through the leap
    c.scale(k);

    final Paint body = Paint()..color = _dark.withValues(alpha: 0.95 * op);
    // Stretched leaping cat (facing left), feet near y=0.
    c.drawPath(
      Path()
        ..moveTo(62, -18)
        ..cubicTo(66, -40, 34, -46, 8, -42)
        ..cubicTo(-18, -40, -44, -44, -58, -33)
        ..cubicTo(-68, -27, -66, -12, -55, -9)
        ..cubicTo(-38, -5, -8, -12, 16, -14)
        ..cubicTo(40, -16, 58, -12, 62, -18)
        ..close(),
      body,
    );
    // Extended legs.
    final Paint leg = Paint()
      ..color = _dark.withValues(alpha: 0.95 * op)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    c.drawLine(
      const Offset(-46, -28),
      const Offset(-66, 2),
      leg,
    ); // front reach
    c.drawLine(const Offset(-34, -26), const Offset(-44, 4), leg);
    c.drawLine(const Offset(34, -26), const Offset(58, 0), leg); // back drive
    c.drawLine(const Offset(46, -22), const Offset(70, -2), leg);
    // Tail streaming back.
    c.drawPath(
      Path()
        ..moveTo(60, -22)
        ..cubicTo(86, -28, 102, -44, 110, -64),
      Paint()
        ..color = _dark.withValues(alpha: 0.95 * op)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    // Saber fangs.
    final Paint fang = Paint()
      ..color = _ivory.withValues(alpha: 0.9 * op)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    c.drawLine(const Offset(-56, -12), const Offset(-58, 8), fang);
    c.drawLine(const Offset(-50, -12), const Offset(-51, 6), fang);
    // Eye. Skip when faint to avoid a stray dot during the fade.
    if (op > 0.4) {
      c.drawCircle(
        const Offset(-54, -24),
        3.5,
        Paint()..color = AppColors.humanityWarm.withValues(alpha: 0.9 * op),
      );
    }
    c.restore();
  }

  /// 30 falling leaves drifting down over the forest scene.
  void _leaves(Canvas c, double w, double vp, double gy, double op) {
    final Paint p = Paint();
    final double top = gy - vp * 0.4; // leaves start up in the canopy
    final Random r = Random(33);
    for (int i = 0; i < 30; i++) {
      final double speed = 0.3 + r.nextDouble() * 0.4; // fall rate
      final double yPhase =
          (time * speed + r.nextDouble() * 5) % 1.0; // 0..1 fall
      final double y = top + yPhase * (vp * 0.55);
      final double x =
          (r.nextDouble() + sin(time * 0.6 + i) * 0.03) * w; // sideways drift
      p.color = _leaf.withValues(
        alpha: (0.4 - yPhase * 0.25) * op,
      ); // fade as it falls
      c.drawCircle(Offset(x % w, y), 1.8 + r.nextDouble() * 1.5, p);
    }
  }

  // ===========================================================================
  // ACT 3, THE CAMP: cave dwelling, bonfire, and a city skyline rising.
  // ===========================================================================
  /// Act 3: warm ground, rising city, distant fires, cave, bonfire, figures.
  void _drawCamp(Canvas c, double w, double vp, double gy, double op) {
    // Warm ground.
    c.drawRect(
      Rect.fromLTWH(0, gy, w, vp * 0.5),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.humanityDark.withValues(alpha: 0.8 * op),
            AppColors.humanityBg.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, gy, w, vp * 0.5)),
    );

    _city(c, w, vp, gy, op);
    _distantFires(c, w, vp, gy, op);
    _cave(c, w, vp, gy, op);
    _bonfire(c, w, vp, gy, op);
    _fireFigures(c, w, vp, gy, op);
  }

  /// City skyline of 30 lit buildings that grow upward late in the act.
  void _city(Canvas c, double w, double vp, double gy, double op) {
    final double rise = ((progress - 0.55) / 0.35).clamp(
      0.0,
      1.0,
    ); // 0..1 build height
    if (rise <= 0) return; // skyline not yet emerging
    final Random r = Random(42); // fixed seed: stable skyline
    final Paint building = Paint()
      ..color = AppColors.humanityBg.withValues(alpha: 0.7 * op);
    final Paint win = Paint()
      ..color = AppColors.humanityWarm.withValues(alpha: 0.5 * op * rise);

    for (int i = 0; i < 30; i++) {
      final double bx = (i / 30) * w + r.nextDouble() * 8; // building x
      final double bw = w / 30 * (0.5 + r.nextDouble() * 0.4); // building width
      final double bh =
          (vp * 0.04 + r.nextDouble() * vp * 0.16) *
          rise; // height grows with rise
      c.drawRect(Rect.fromLTWH(bx, gy - bh, bw, bh), building);
      if (bh > 25) {
        // only tall enough buildings get window rows
        final int floors = (bh / 10).floor(); // 10px floor pitch
        for (int f = 0; f < floors; f++) {
          final int perFloor = (bw / 7).floor(); // 7px window pitch
          for (int wi = 0; wi < perFloor; wi++) {
            if (r.nextDouble() > 0.4) {
              // ~60% of windows are lit
              c.drawRect(
                Rect.fromLTWH(bx + 2 + wi * 7, gy - bh + 3 + f * 10, 3, 4),
                win,
              );
            }
          }
        }
      }
    }
  }

  /// Four small fires in the distance: a soft glow with a warm core each.
  void _distantFires(Canvas c, double w, double vp, double gy, double op) {
    for (final double pos in <double>[0.30, 0.40, 0.60, 0.70]) {
      // fire x fractions
      final Offset f = Offset(w * pos, gy - 3);
      c.drawCircle(
        f,
        5,
        Paint()
          ..color = AppColors.humanityFire.withValues(alpha: 0.2 * op)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      c.drawCircle(
        f,
        2,
        Paint()..color = AppColors.humanityWarm.withValues(alpha: 0.6 * op),
      );
    }
  }

  /// Cave dwelling: rock mound, lit entrance, a seated figure, wall paintings.
  void _cave(Canvas c, double w, double vp, double gy, double op) {
    final double cx = w * 0.10; // cave centre, far left
    final Path rock = Path()
      ..moveTo(0, gy)
      ..lineTo(0, gy - vp * 0.10)
      ..cubicTo(
        w * 0.02,
        gy - vp * 0.18,
        w * 0.08,
        gy - vp * 0.20,
        w * 0.13,
        gy - vp * 0.15,
      )
      ..cubicTo(
        w * 0.17,
        gy - vp * 0.11,
        w * 0.19,
        gy - vp * 0.05,
        w * 0.19,
        gy,
      )
      ..close();
    _fill(c, rock, op, rim: 0.16);

    c.drawCircle(
      Offset(cx, gy - vp * 0.01),
      vp * 0.05,
      Paint()
        ..color = AppColors.humanityFire.withValues(alpha: 0.35 * op)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, vp * 0.03),
    );

    final Path arch = Path()
      ..moveTo(cx - w * 0.022, gy)
      ..lineTo(cx - w * 0.022, gy - vp * 0.04)
      ..cubicTo(
        cx - w * 0.02,
        gy - vp * 0.075,
        cx + w * 0.02,
        gy - vp * 0.075,
        cx + w * 0.022,
        gy - vp * 0.04,
      )
      ..lineTo(cx + w * 0.022, gy)
      ..close();
    c.drawPath(
      arch,
      Paint()..color = const Color(0xff050200).withValues(alpha: 0.95 * op),
    );

    final double fl = 0.7 + 0.3 * sin(time * 5.0); // 0.4..1.0 fire flicker
    c.drawCircle(
      Offset(cx, gy - vp * 0.012),
      vp * 0.012 * fl,
      Paint()
        ..color = AppColors.humanityWarm.withValues(alpha: 0.85 * op)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    c.drawCircle(
      Offset(cx + w * 0.013, gy - vp * 0.022),
      vp * 0.009,
      Paint()..color = _dark.withValues(alpha: 0.9 * op),
    );

    // Cave paintings: an ochre beast and a handprint.
    final Paint ochre = Paint()
      ..color = AppColors.humanityFire.withValues(alpha: 0.5 * op)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final double bx = w * 0.04; // beast painting anchor x
    final double by = gy - vp * 0.115; // anchor y, high on the rock
    c.drawPath(
      Path()
        ..moveTo(bx, by)
        ..cubicTo(
          bx + w * 0.012,
          by - vp * 0.014,
          bx + w * 0.032,
          by - vp * 0.014,
          bx + w * 0.044,
          by,
        )
        ..moveTo(bx + w * 0.006, by)
        ..lineTo(bx + w * 0.004, by + vp * 0.015)
        ..moveTo(bx + w * 0.038, by)
        ..lineTo(bx + w * 0.04, by + vp * 0.015)
        ..moveTo(bx + w * 0.044, by)
        ..lineTo(bx + w * 0.055, by - vp * 0.008),
      ochre,
    );
    final Offset palm = Offset(w * 0.118, gy - vp * 0.095);
    c.drawCircle(
      palm,
      vp * 0.006,
      Paint()..color = AppColors.humanityFire.withValues(alpha: 0.45 * op),
    );
    for (int f = 0; f < 4; f++) {
      final double ang = -pi / 2 + (f - 1.5) * 0.32; // four fingers fanned up
      c.drawLine(
        palm,
        palm + Offset(cos(ang) * vp * 0.012, sin(ang) * vp * 0.012),
        ochre,
      );
    }
  }

  /// Central bonfire: glow, five flickering flame tongues, embers, logs.
  void _bonfire(Canvas c, double w, double vp, double gy, double op) {
    final double cx = w * 0.5; // fire is centred
    final double baseY = gy - vp * 0.01; // flame base just above ground
    final Paint paint = Paint();

    // Warm glow.
    paint
      ..color = AppColors.humanityFire.withValues(alpha: 0.25 * op)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, vp * 0.10);
    c.drawCircle(Offset(cx, baseY - vp * 0.05), vp * 0.08, paint);
    paint.maskFilter = null;

    const List<_Flame> flames = [
      _Flame(-0.03, 0.05, 0.16, AppColors.humanityFire),
      _Flame(0.0, 0.06, 0.22, AppColors.humanityWarm),
      _Flame(0.025, 0.04, 0.18, AppColors.humanityFire),
      _Flame(-0.015, 0.045, 0.20, Color(0xffffe0a0)),
      _Flame(0.035, 0.035, 0.13, AppColors.humanityWarm),
    ];
    for (int i = 0; i < flames.length; i++) {
      final _Flame f = flames[i];
      final double flicker =
          sin(time * 4.0 + i * 1.7) * 0.15 + 0.85; // 0.7..1.0 height jitter
      final double fh = vp * f.height * flicker; // tongue height
      final double fw = w * f.width; // tongue half-width
      final double fx = cx + w * f.offsetX; // tongue x about centre

      final Path tongue = Path()
        ..moveTo(fx - fw, baseY)
        ..quadraticBezierTo(fx - fw * 0.3, baseY - fh * 0.7, fx, baseY - fh)
        ..quadraticBezierTo(fx + fw * 0.3, baseY - fh * 0.7, fx + fw, baseY)
        ..close();

      paint
        ..color = f.color.withValues(alpha: 0.3 * op)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      c.drawPath(tongue, paint);
      paint
        ..color = f.color.withValues(alpha: 0.85 * op)
        ..maskFilter = null;
      c.drawPath(tongue, paint);
    }

    // Embers.
    for (int i = 0; i < 18; i++) {
      final double phase = (time * 0.5 + i * 0.4) % 2.0; // 0..2 cycle
      if (phase > 1.0) continue; // second half: ember is gone, rest period
      final double ex = cx + sin(i * 2.3) * w * 0.05; // scattered x
      final double ey =
          baseY - vp * 0.05 - phase * vp * 0.2; // rises as phase grows
      paint
        ..color = AppColors.humanityWarm.withValues(
          alpha: ((1.0 - phase) * op * 0.7).clamp(0.0, 0.7),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      c.drawCircle(Offset(ex, ey), 2, paint);
      paint.maskFilter = null;
    }

    // Logs.
    paint.color = const Color(0xff1a0800).withValues(alpha: 0.8 * op);
    c.drawOval(
      Rect.fromCenter(
        center: Offset(cx - w * 0.02, baseY + 3),
        width: w * 0.08,
        height: vp * 0.012,
      ),
      paint,
    );
    c.drawOval(
      Rect.fromCenter(
        center: Offset(cx + w * 0.015, baseY + 5),
        width: w * 0.07,
        height: vp * 0.01,
      ),
      paint,
    );
  }

  /// Four figures (torso, head, two legs) seated around the bonfire, swaying.
  void _fireFigures(Canvas c, double w, double vp, double gy, double op) {
    final double cx = w * 0.5; // around the centred fire
    const List<double> pos = [
      -0.11,
      -0.06,
      0.06,
      0.10,
    ]; // figures flank the fire
    for (int i = 0; i < pos.length; i++) {
      final double fx = cx + w * pos[i];
      final double fy = gy - vp * 0.005; // feet near ground
      final double figureH = vp * 0.055; // figure height unit
      final double sway = sin(time * 0.8 + i * 1.5) * 2; // gentle lean
      final Paint p = Paint()
        ..color = const Color(0xff1a0a00).withValues(alpha: 0.75 * op);
      c.drawOval(
        Rect.fromCenter(
          center: Offset(fx + sway * 0.5, fy - figureH * 0.4),
          width: figureH * 0.3,
          height: figureH * 0.5,
        ),
        p,
      );
      c.drawCircle(Offset(fx + sway, fy - figureH * 0.8), figureH * 0.12, p);
      c.drawRect(
        Rect.fromLTWH(
          fx - figureH * 0.08,
          fy - figureH * 0.15,
          figureH * 0.06,
          figureH * 0.18,
        ),
        p,
      );
      c.drawRect(
        Rect.fromLTWH(
          fx + figureH * 0.02,
          fy - figureH * 0.15,
          figureH * 0.06,
          figureH * 0.18,
        ),
        p,
      );
    }
  }

  // ===========================================================================
  // Shared actors: mammoth, hunters, thrown spears.
  // ===========================================================================

  /// Draws a woolly mammoth (body, legs, trunk, tusks, optional fur fringe).
  // A woolly mammoth in unit coordinates, scaled by [k] and centred at
  // ([cx], [gy]) with feet on the ground line. [body] tints it for depth.
  void _mammoth(
    Canvas c,
    double cx,
    double gy,
    double k,
    double op,
    Color body, {
    bool fringe = true,
  }) {
    c.save();
    c.translate(cx, gy);
    c.scale(k);

    final Paint fill = Paint()..color = body.withValues(alpha: 0.95 * op);
    final Path p = Path()
      ..moveTo(75, -50)
      ..cubicTo(88, -110, 42, -126, 10, -120)
      ..cubicTo(-8, -145, -36, -140, -52, -117)
      ..cubicTo(-78, -96, -88, -70, -82, -44)
      ..cubicTo(-74, -32, -32, -28, 0, -28)
      ..cubicTo(44, -28, 70, -34, 75, -50)
      ..close();
    for (final double lx in <double>[-52, -20, 28, 60]) {
      p.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(lx, -46, 22, 46),
          const Radius.circular(7),
        ),
      );
    }
    final double sway = sin(time * 1.4) * 6; // trunk swing in unit coords
    p.addPath(
      Path()
        ..moveTo(-80, -72)
        ..cubicTo(-96, -50, -98 + sway, -22, -90 + sway, -6)
        ..cubicTo(-86 + sway, -2, -78, -12, -74, -30)
        ..cubicTo(-76, -50, -72, -62, -80, -72)
        ..close(),
      Offset.zero,
    );
    c.drawPath(p, fill);
    c.drawCircle(const Offset(-34, -112), 13, fill);

    final Paint tusk = Paint()
      ..color = _ivory.withValues(alpha: 0.85 * op)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    for (final double dy in <double>[0, 12]) {
      c.drawPath(
        Path()
          ..moveTo(-72, -58 + dy)
          ..cubicTo(-104, -28 + dy, -126, -18 + dy, -120, -50 + dy),
        tusk,
      );
    }

    if (fringe) {
      final Paint fur = Paint()
        ..color = body.withValues(alpha: 0.9 * op)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      for (int i = 0; i < 9; i++) {
        final double fxp = -50 + i * 14.0;
        c.drawLine(Offset(fxp, -28), Offset(fxp - 3, -10), fur);
      }
    }
    if (op > 0.4) {
      c.drawCircle(
        const Offset(-58, -100),
        4,
        Paint()..color = AppColors.humanityWarm.withValues(alpha: 0.7 * op),
      );
    }
    c.restore();
  }

  /// Draws a row of standing hunters at the given x fractions [xs].
  void _hunters(
    Canvas c,
    double w,
    double vp,
    double gy,
    double op,
    List<double> xs,
  ) {
    for (int i = 0; i < xs.length; i++) {
      _hunter(c, w * xs[i], gy, vp, w, op, i);
    }
  }

  /// One standing hunter, arm and spear animated through a throwing motion.
  void _hunter(
    Canvas c,
    double hx,
    double gy,
    double vp,
    double w,
    double op,
    int i,
  ) {
    final double fh = vp * 0.07; // standing figure height
    final double a = sin(time * 2.2 + i * 1.3); // -1..1 throw-arm phase

    final Paint body = Paint()
      ..color = _dark.withValues(alpha: 0.92 * op)
      ..style = PaintingStyle.stroke
      ..strokeWidth = vp * 0.007
      ..strokeCap = StrokeCap.round;

    final Offset hip = Offset(hx, gy - fh * 0.42);
    final Offset shoulder = Offset(hx + w * 0.006, gy - fh * 0.85);
    c.drawLine(hip, Offset(hx - w * 0.008, gy), body);
    c.drawLine(hip, Offset(hx + w * 0.012, gy), body);
    c.drawLine(hip, shoulder, body);
    c.drawCircle(
      Offset(shoulder.dx + w * 0.003, shoulder.dy - fh * 0.16),
      fh * 0.13,
      Paint()..color = _dark.withValues(alpha: 0.92 * op),
    );

    final Offset hand = Offset(
      shoulder.dx + w * (0.004 + 0.012 * a),
      shoulder.dy - fh * (0.1 - 0.18 * a),
    ); // throwing hand swings with phase a
    c.drawLine(shoulder, hand, body);
    final Offset tip =
        hand + Offset(w * 0.05, -vp * 0.02 - fh * 0.1 * a); // spear point ahead
    final Offset butt =
        hand - Offset(w * 0.02, vp * 0.008); // spear tail behind hand
    final Paint spear = Paint()
      ..color = _ivory.withValues(alpha: 0.55 * op)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    c.drawLine(butt, tip, spear);
    c.drawCircle(tip, 1.8, Paint()..color = _ivory.withValues(alpha: 0.7 * op));
    c.drawLine(shoulder, Offset(shoulder.dx + w * 0.012, gy - fh * 0.5), body);
  }

  /// Two spears arcing through the air from [startX] across [span] of width.
  void _flyingSpears(
    Canvas c,
    double w,
    double vp,
    double gy,
    double op,
    double startX,
    double span,
  ) {
    final Paint spear = Paint()..strokeCap = StrokeCap.round;
    for (int i = 0; i < 2; i++) {
      final double phase = (time * 0.6 + i * 0.5) % 1.0; // 0..1 along the throw
      final double sxp = w * (startX + phase * span); // travels along span
      final double syp =
          gy - vp * 0.085 - sin(phase * pi) * vp * 0.02; // arc apex mid-flight
      final double a = sin(phase * pi) * 0.7 * op; // fade in/out at the ends
      if (a <= 0.02) continue; // skip near-invisible frames
      final Offset tip = Offset(sxp + w * 0.018, syp - vp * 0.004);
      final Offset butt = Offset(sxp - w * 0.014, syp + vp * 0.003);
      spear
        ..color = _ivory.withValues(alpha: 0.6 * a)
        ..strokeWidth = 1.4;
      c.drawLine(butt, tip, spear);
      c.drawCircle(
        tip,
        1.8,
        Paint()..color = _ivory.withValues(alpha: 0.8 * a),
      );
    }
  }

  /// Repaints when scroll progress or the animation clock changes.
  @override
  bool shouldRepaint(covariant HumanityStoryPainter old) =>
      old.progress != progress || old.time != time;
}

/// Data for one bonfire flame tongue: x offset, half-width, height, colour.
class _Flame {
  const _Flame(this.offsetX, this.width, this.height, this.color);
  final double offsetX; // x position relative to fire centre, fraction of w
  final double width; // half-width, fraction of w
  final double height; // height, fraction of vp
  final Color color; // tongue tint
}
