import 'package:safeandromeda/core/hooks/hooks.dart';

class FutureEra extends StatelessWidget {
  const FutureEra({super.key});

  static const int eraIndex = 8;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, _) {
        final double progress = pro.eraProgressFor(eraIndex);
        final double lightProgress = (progress * 1.5).clamp(0.0, 1.0);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: Color.lerp(
            AppColors.futureBg,
            AppColors.futureLight,
            lightProgress,
          )!,
          nextBackgroundColor: AppColors.portfolioBg,
          useDarkText: progress > 0.4,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: StarFieldPainter(
                    progress: progress,
                    starCount: 100,
                    baseColor: AppColors.white,
                    maxOpacity: (1.0 - lightProgress).clamp(0.0, 0.8),
                    seed: 999,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: AppColors.futureLight
                      .withValues(alpha: lightProgress * 0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
