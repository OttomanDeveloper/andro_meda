import 'package:safeandromeda/core/hooks/hooks.dart';

class GalaxiesEra extends StatelessWidget {
  const GalaxiesEra({super.key});

  static const int eraIndex = 3;

  static const List<NebulaCloud> _galacticClouds = [
    NebulaCloud(
        x: 0.5,
        y: 0.4,
        radius: 0.25,
        color: AppColors.galaxiesArm,
        opacity: 0.35,
        driftSpeed: 0.03),
    NebulaCloud(
        x: 0.45,
        y: 0.45,
        radius: 0.18,
        color: AppColors.galaxiesCore,
        opacity: 0.27,
        driftSpeed: -0.02),
    NebulaCloud(
        x: 0.55,
        y: 0.35,
        radius: 0.2,
        color: AppColors.galaxiesArm,
        opacity: 0.22,
        driftSpeed: 0.025),
    NebulaCloud(
        x: 0.4,
        y: 0.5,
        radius: 0.15,
        color: AppColors.galaxiesDeep,
        opacity: 0.18,
        driftSpeed: -0.01),
  ];

  @override
  Widget build(BuildContext context) {
    final int starCount = AppSettings.particleCount(context, desktop: 200);

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
                  backgroundColor: AppColors.galaxiesBg,
                  nextBackgroundColor: AppColors.solarBg,
                  interactionHint: 'DRAG TO ROTATE',
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: StarFieldPainter(
                            progress: progress,
                            time: anim.time,
                            starCount: starCount,
                            baseColor: AppColors.white,
                            maxOpacity: 0.6,
                            seed: 123,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: NebulaPainter(
                            progress: progress,
                            clouds: _galacticClouds,
                            time: anim.time,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: GalaxyRotator(eraProgress: progress),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _StarBirthPainter(
                            progress: progress,
                            time: anim.time,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.galaxiesArm,
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

class _StarBirthPainter extends CustomPainter {
  const _StarBirthPainter({required this.progress, required this.time});
  final double progress;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.2) return;
    final Paint paint = Paint();
    final Random r = Random(33);
    final Offset galaxyCenter = Offset(size.width * 0.5, size.height * 0.4);

    for (int burst = 0; burst < 5; burst++) {
      final double burstPhase = (time * 0.3 + burst * 1.7) % 3.0;
      if (burstPhase > 1.0) continue;

      final double angle = r.nextDouble() * pi * 2;
      final double dist = 30 + r.nextDouble() * size.width * 0.2;
      final Offset burstCenter = Offset(
        galaxyCenter.dx + cos(angle + burst) * dist,
        galaxyCenter.dy + sin(angle + burst) * dist * 0.6,
      );

      for (int ray = 0; ray < 6; ray++) {
        final double rayAngle = (ray / 6) * pi * 2;
        final double rayLength = burstPhase * 15;
        final double alpha =
            ((1.0 - burstPhase) * 0.8 * progress).clamp(0.0, 0.8);

        paint.color = AppColors.firstStarsBright.withValues(alpha: alpha);
        paint.strokeWidth = 1;
        paint.style = PaintingStyle.stroke;
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

        canvas.drawLine(
          burstCenter,
          Offset(
            burstCenter.dx + cos(rayAngle) * rayLength,
            burstCenter.dy + sin(rayAngle) * rayLength,
          ),
          paint,
        );
      }

      // Center flash
      paint.style = PaintingStyle.fill;
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      paint.color = AppColors.firstStarsBright.withValues(
          alpha: ((1.0 - burstPhase) * 0.9 * progress).clamp(0.0, 0.9));
      canvas.drawCircle(burstCenter, 3 * (1.0 - burstPhase), paint);
      paint.maskFilter = null;
    }
  }

  @override
  bool shouldRepaint(covariant _StarBirthPainter old) =>
      old.progress != progress || old.time != time;
}
