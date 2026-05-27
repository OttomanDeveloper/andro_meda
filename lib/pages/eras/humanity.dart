import 'package:safeandromeda/core/hooks/hooks.dart';

class HumanityEra extends StatelessWidget {
  const HumanityEra({super.key});

  static const int eraIndex = 7;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

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
                        starCount: 60,
                        baseColor: AppColors.white,
                        maxOpacity: 0.2,
                        seed: 789,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _HorizonPainter(progress: progress),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: NebulaPainter(
                        progress: progress,
                        time: anim.time,
                        clouds: const [
                          NebulaCloud(
                              x: 0.5,
                              y: 0.6,
                              radius: 0.25,
                              color: AppColors.humanityFire,
                              opacity: 0.4,
                              driftSpeed: 0.0),
                          NebulaCloud(
                              x: 0.5,
                              y: 0.55,
                              radius: 0.35,
                              color: AppColors.humanityWarm,
                              opacity: 0.2,
                              driftSpeed: 0.0),
                          NebulaCloud(
                              x: 0.48,
                              y: 0.65,
                              radius: 0.15,
                              color: AppColors.humanityFire,
                              opacity: 0.35,
                              driftSpeed: 0.0),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: size.height * 0.18,
                    left: 0,
                    right: 0,
                    height: size.height * 0.25,
                    child: CustomPaint(
                      painter: _FirePainter(progress: progress),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FirePainter extends CustomPainter {
  const _FirePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w * 0.5;
    final double baseY = h * 0.85;
    final double fireOpacity = progress.clamp(0.0, 1.0);

    if (fireOpacity < 0.05) return;

    // Draw multiple flame tongues with varying heights
    const List<_FlameTongue> tongues = [
      _FlameTongue(offsetX: -0.02, width: 0.025, height: 0.5, hue: 0),
      _FlameTongue(offsetX: 0.0, width: 0.03, height: 0.7, hue: 1),
      _FlameTongue(offsetX: 0.015, width: 0.02, height: 0.55, hue: 0),
      _FlameTongue(offsetX: -0.01, width: 0.022, height: 0.65, hue: 1),
      _FlameTongue(offsetX: 0.008, width: 0.018, height: 0.45, hue: 2),
      _FlameTongue(offsetX: -0.018, width: 0.015, height: 0.35, hue: 2),
      _FlameTongue(offsetX: 0.022, width: 0.012, height: 0.3, hue: 0),
    ];

    for (int i = 0; i < tongues.length; i++) {
      final _FlameTongue t = tongues[i];
      // Pseudo-random flickering based on progress and tongue index
      final double flicker = _flickerValue(progress, i);
      final double tongueHeight = t.height * (0.7 + 0.3 * flicker);

      final double tx = cx + w * t.offsetX;
      final double tw = w * t.width;
      final double th = h * tongueHeight;

      final Color flameColor = switch (t.hue) {
        0 => AppColors.humanityFire,
        1 => AppColors.humanityWarm,
        _ => const Color(0xffffe0a0),
      };

      final Path flamePath = Path();
      flamePath.moveTo(tx - tw, baseY);
      flamePath.quadraticBezierTo(
        tx - tw * 0.5,
        baseY - th * 0.6,
        tx,
        baseY - th,
      );
      flamePath.quadraticBezierTo(
        tx + tw * 0.5,
        baseY - th * 0.6,
        tx + tw,
        baseY,
      );
      flamePath.close();

      // Glow
      final Paint glowPaint = Paint()
        ..color = flameColor.withValues(alpha: fireOpacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawPath(flamePath, glowPaint);

      // Fill
      final Paint fillPaint = Paint()
        ..color = flameColor.withValues(alpha: fireOpacity * 0.8)
        ..style = PaintingStyle.fill;
      canvas.drawPath(flamePath, fillPaint);
    }

    // Ember particles rising from fire
    const int emberCount = 12;
    for (int i = 0; i < emberCount; i++) {
      final double seed = (i * 137.508 + progress * 200) % 100 / 100;
      final double emberX = cx + w * 0.06 * (seed - 0.5) * 2;
      final double emberY = baseY - h * 0.3 - h * 0.4 * ((seed * 3 + progress * 2 + i * 0.3) % 1.0);
      final double emberAlpha = (1.0 - ((seed * 3 + progress * 2 + i * 0.3) % 1.0)) * fireOpacity;

      if (emberAlpha > 0.05) {
        final Paint emberPaint = Paint()
          ..color = AppColors.humanityWarm.withValues(alpha: emberAlpha * 0.6);
        canvas.drawCircle(Offset(emberX, emberY), 1.5, emberPaint);
      }
    }
  }

  double _flickerValue(double progress, int index) {
    // Produces a 0..1 pseudo-flicker based on progress and index
    final double v = (progress * 8.0 + index * 2.3) % 1.0;
    return (v * 6.283).clamp(0.0, 6.283) == 0 ? 1.0 : (sin(v * 6.283) * 0.5 + 0.5);
  }

  @override
  bool shouldRepaint(covariant _FirePainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class _HorizonPainter extends CustomPainter {
  const _HorizonPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double horizonY = h * 0.7;
    final double opacity = progress.clamp(0.0, 1.0);

    if (opacity < 0.05) return;

    // Subtle horizon line
    final Paint linePaint = Paint()
      ..color = AppColors.humanityDark.withValues(alpha: opacity * 0.4)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(w * 0.1, horizonY),
      Offset(w * 0.9, horizonY),
      linePaint,
    );

    // Distant campfires along horizon — small glowing dots
    const List<double> campfirePositions = [0.15, 0.28, 0.42, 0.62, 0.75, 0.85];
    for (final double px in campfirePositions) {
      final double cx = w * px;
      final double cy = horizonY - 2;

      // Warm glow
      final Paint glowPaint = Paint()
        ..color = AppColors.humanityFire.withValues(alpha: opacity * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(cx, cy), 4, glowPaint);

      // Bright dot
      final Paint dotPaint = Paint()
        ..color = AppColors.humanityWarm.withValues(alpha: opacity * 0.5);
      canvas.drawCircle(Offset(cx, cy), 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HorizonPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class _FlameTongue {
  const _FlameTongue({
    required this.offsetX,
    required this.width,
    required this.height,
    required this.hue,
  });

  final double offsetX;
  final double width;
  final double height;
  final int hue;
}
