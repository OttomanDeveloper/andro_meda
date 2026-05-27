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
        opacity: 0.2,
        driftSpeed: 0.03),
    NebulaCloud(
        x: 0.45,
        y: 0.45,
        radius: 0.18,
        color: AppColors.galaxiesCore,
        opacity: 0.15,
        driftSpeed: -0.02),
    NebulaCloud(
        x: 0.55,
        y: 0.35,
        radius: 0.2,
        color: AppColors.galaxiesArm,
        opacity: 0.12,
        driftSpeed: 0.025),
    NebulaCloud(
        x: 0.4,
        y: 0.5,
        radius: 0.15,
        color: AppColors.galaxiesDeep,
        opacity: 0.1,
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
