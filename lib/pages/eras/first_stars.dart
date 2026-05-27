import 'package:safeandromeda/core/hooks/hooks.dart';

class FirstStarsEra extends StatelessWidget {
  const FirstStarsEra({super.key});

  static const int eraIndex = 2;

  @override
  Widget build(BuildContext context) {
    final int starCount = AppSettings.particleCount(context, desktop: 150);

    return Consumer<AnimationProvider>(
      builder: (_, AnimationProvider anim, _) {
        return Selector<ScrollProvider, double>(
          selector: (_, ScrollProvider pro) =>
              (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
          builder: (_, double progress, _) {
            return EraWrapper(
              eraIndex: eraIndex,
              backgroundColor: AppColors.firstStarsBg,
              nextBackgroundColor: AppColors.galaxiesBg,
              interactionHint: 'TAP TO IGNITE STARS',
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.firstStarsBg,
                            AppColors.firstStarsDeep,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: StarFieldPainter(
                        progress: progress,
                        time: anim.time,
                        starCount: starCount,
                        baseColor: AppColors.firstStarsGlow,
                        maxOpacity: progress.clamp(0.0, 1.0),
                        seed: 77,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: StarIgniter(eraProgress: progress),
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
