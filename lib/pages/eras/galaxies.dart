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
                    starCount: starCount,
                    baseColor: AppColors.white,
                    maxOpacity: 0.6,
                    seed: 123,
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: NebulaPainter(
                    progress: progress,
                    clouds: _galacticClouds,
                  ),
                ),
              ),
              Positioned.fill(
                child: GalaxyRotator(eraProgress: progress),
              ),
            ],
          ),
        );
      },
    );
  }
}
