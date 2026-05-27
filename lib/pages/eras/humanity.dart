import 'package:safeandromeda/core/hooks/hooks.dart';

class HumanityEra extends StatelessWidget {
  const HumanityEra({super.key});

  static const int eraIndex = 7;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, _) {
        final double progress = pro.eraProgressFor(eraIndex);

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
                    starCount: 60,
                    baseColor: AppColors.white,
                    maxOpacity: 0.2,
                    seed: 789,
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.25,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: size.width * 0.004,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.humanityFire
                              .withValues(alpha: progress.clamp(0.0, 0.9)),
                          AppColors.humanityWarm
                              .withValues(alpha: progress.clamp(0.0, 0.5)),
                          AppColors.parent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: NebulaPainter(
                    progress: progress,
                    clouds: const [
                      NebulaCloud(
                          x: 0.5,
                          y: 0.65,
                          radius: 0.12,
                          color: AppColors.humanityFire,
                          opacity: 0.3,
                          driftSpeed: 0.0),
                      NebulaCloud(
                          x: 0.5,
                          y: 0.6,
                          radius: 0.2,
                          color: AppColors.humanityWarm,
                          opacity: 0.15,
                          driftSpeed: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
