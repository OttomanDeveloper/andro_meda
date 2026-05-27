import 'package:safeandromeda/core/hooks/hooks.dart';

class HumanityEra extends StatelessWidget {
  const HumanityEra({super.key});

  static const int eraIndex = 7;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<CursorProvider>(
      builder: (_, CursorProvider cursor, _) {
        return Consumer<AnimationProvider>(
          builder: (_, AnimationProvider anim, _) {
            return Selector<ScrollProvider, double>(
              selector: (_, ScrollProvider pro) =>
                  (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
              builder: (_, double progress, _) {
                return EraWrapper(
                  eraIndex: eraIndex,
                  backgroundColor: AppColors.humanityBg,
                  nextBackgroundColor: AppColors.futureBg,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: StarFieldPainter(
                            progress: progress,
                            time: anim.time,
                            starCount: 80,
                            baseColor: AppColors.white,
                            maxOpacity: 0.3,
                            seed: 789,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _HumanityScenePainter(
                            progress: progress,
                            time: anim.time,
                            viewportHeight: size.height,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: NebulaPainter(
                            progress: progress,
                            time: anim.time,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                            clouds: const [
                              NebulaCloud(
                                x: 0.5, y: 0.28,
                                radius: 0.2,
                                color: AppColors.humanityFire,
                                opacity: 0.5,
                                driftSpeed: 0.0,
                              ),
                              NebulaCloud(
                                x: 0.5, y: 0.25,
                                radius: 0.3,
                                color: AppColors.humanityWarm,
                                opacity: 0.3,
                                driftSpeed: 0.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.humanityFire,
                            seed: eraIndex * 100 + 99,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _HumanityScenePainter extends CustomPainter {
  const _HumanityScenePainter({
    required this.progress,
    required this.time,
    required this.viewportHeight,
  });

  final double progress;
  final double time;
  final double viewportHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double vp = viewportHeight;
    final double opacity = (progress * 2.0).clamp(0.0, 1.0);

    final Paint paint = Paint();

    // Ground / horizon at 40% of first viewport
    final double groundY = vp * 0.6;

    // Ground gradient below horizon
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.humanityBg,
        AppColors.humanityDark.withValues(alpha: 0.8),
      ],
    ).createShader(Rect.fromLTWH(0, groundY, w, vp * 0.5));
    canvas.drawRect(Rect.fromLTWH(0, groundY, w, vp * 0.5), paint);
    paint.shader = null;

    // --- CENTRAL BONFIRE ---
    final double cx = w * 0.5;
    final double fireBaseY = groundY - vp * 0.01;

    // Large warm glow behind fire
    paint.color = AppColors.humanityFire.withValues(alpha: 0.25 * opacity);
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, vp * 0.12);
    canvas.drawCircle(Offset(cx, fireBaseY - vp * 0.05), vp * 0.08, paint);
    paint.maskFilter = null;

    // Flame tongues — much wider and taller
    const List<_Flame> flames = [
      _Flame(-0.03, 0.05, 0.20, AppColors.humanityFire),
      _Flame(0.0, 0.06, 0.28, AppColors.humanityWarm),
      _Flame(0.025, 0.04, 0.22, AppColors.humanityFire),
      _Flame(-0.015, 0.045, 0.25, Color(0xffffe0a0)),
      _Flame(0.035, 0.035, 0.16, AppColors.humanityWarm),
      _Flame(-0.04, 0.03, 0.14, AppColors.humanityFire),
    ];

    for (int i = 0; i < flames.length; i++) {
      final _Flame f = flames[i];
      final double flicker = (sin(time * 4.0 + i * 1.7) * 0.15 + 0.85);
      final double fh = vp * f.height * flicker * opacity;
      final double fw = w * f.width;
      final double fx = cx + w * f.offsetX;

      final Path tongue = Path();
      tongue.moveTo(fx - fw, fireBaseY);
      tongue.quadraticBezierTo(fx - fw * 0.3, fireBaseY - fh * 0.7, fx, fireBaseY - fh);
      tongue.quadraticBezierTo(fx + fw * 0.3, fireBaseY - fh * 0.7, fx + fw, fireBaseY);
      tongue.close();

      paint.color = f.color.withValues(alpha: 0.3 * opacity);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawPath(tongue, paint);

      paint.color = f.color.withValues(alpha: 0.85 * opacity);
      paint.maskFilter = null;
      canvas.drawPath(tongue, paint);
    }

    // Embers rising
    for (int i = 0; i < 25; i++) {
      final double phase = (time * 0.5 + i * 0.4) % 2.0;
      if (phase > 1.0) continue;
      final double ex = cx + (sin(i * 2.3) * w * 0.06);
      final double ey = fireBaseY - vp * 0.05 - phase * vp * 0.25;
      final double ea = ((1.0 - phase) * opacity * 0.7).clamp(0.0, 0.7);

      paint.color = AppColors.humanityWarm.withValues(alpha: ea);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(ex, ey), 2, paint);
      paint.maskFilter = null;
    }

    // Fire log shapes at base
    paint.color = const Color(0xff1a0800).withValues(alpha: 0.8 * opacity);
    canvas.drawOval(Rect.fromCenter(
      center: Offset(cx - w * 0.02, fireBaseY + 3),
      width: w * 0.08, height: vp * 0.012,
    ), paint);
    canvas.drawOval(Rect.fromCenter(
      center: Offset(cx + w * 0.015, fireBaseY + 5),
      width: w * 0.07, height: vp * 0.01,
    ), paint);

    // --- HUMAN FIGURES around fire ---
    final List<double> figurePositions = [-0.12, -0.07, 0.07, 0.11];
    for (int i = 0; i < figurePositions.length; i++) {
      final double fx2 = cx + w * figurePositions[i];
      final double fy = groundY - vp * 0.005;
      final double figureH = vp * 0.06;
      final double sway = sin(time * 0.8 + i * 1.5) * 2;

      paint.color = const Color(0xff1a0a00).withValues(alpha: 0.7 * opacity);

      // Body — oval
      canvas.drawOval(Rect.fromCenter(
        center: Offset(fx2 + sway * 0.5, fy - figureH * 0.4),
        width: figureH * 0.3, height: figureH * 0.5,
      ), paint);
      // Head — circle
      canvas.drawCircle(
        Offset(fx2 + sway, fy - figureH * 0.8),
        figureH * 0.12, paint,
      );
      // Legs
      canvas.drawRect(Rect.fromLTWH(
        fx2 - figureH * 0.08, fy - figureH * 0.15,
        figureH * 0.06, figureH * 0.18,
      ), paint);
      canvas.drawRect(Rect.fromLTWH(
        fx2 + figureH * 0.02, fy - figureH * 0.15,
        figureH * 0.06, figureH * 0.18,
      ), paint);
    }

    // --- DISTANT CAMPFIRES along horizon ---
    final List<double> distantFires = [0.08, 0.18, 0.32, 0.68, 0.82, 0.92];
    for (final double pos in distantFires) {
      final double dfx = w * pos;
      final double dfy = groundY - 3;

      paint.color = AppColors.humanityFire.withValues(alpha: 0.2 * opacity);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(dfx, dfy), 5, paint);
      paint.maskFilter = null;

      paint.color = AppColors.humanityWarm.withValues(alpha: 0.6 * opacity);
      canvas.drawCircle(Offset(dfx, dfy), 2, paint);
    }

    // --- CITY SKYLINE (appears later in progress) ---
    final double buildProgress = ((progress - 0.4) / 0.4).clamp(0.0, 1.0);
    if (buildProgress > 0) {
      final Random r = Random(42);
      paint.color = AppColors.humanityBg.withValues(alpha: 0.6);
      final Paint winPaint = Paint()
        ..color = AppColors.humanityWarm.withValues(alpha: 0.5 * buildProgress);

      for (int i = 0; i < 30; i++) {
        final double bx = (i / 30) * w + r.nextDouble() * 8;
        final double bw = w / 30 * (0.5 + r.nextDouble() * 0.4);
        final double bh = (30 + r.nextDouble() * 100) * buildProgress;

        canvas.drawRect(
          Rect.fromLTWH(bx, groundY - bh, bw, bh), paint);

        if (bh > 25) {
          final int floors = (bh / 10).floor();
          for (int f = 0; f < floors; f++) {
            final int winsPerFloor = (bw / 7).floor();
            for (int wi = 0; wi < winsPerFloor; wi++) {
              if (r.nextDouble() > 0.35) {
                canvas.drawRect(
                  Rect.fromLTWH(bx + 2 + wi * 7, groundY - bh + 3 + f * 10, 3, 4),
                  winPaint,
                );
              }
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HumanityScenePainter old) =>
      old.progress != progress || old.time != time;
}

class _Flame {
  const _Flame(this.offsetX, this.width, this.height, this.color);
  final double offsetX;
  final double width;
  final double height;
  final Color color;
}
