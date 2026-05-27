import 'package:safeandromeda/core/hooks/hooks.dart';

class FirstStarsEra extends StatelessWidget {
  const FirstStarsEra({super.key});

  static const int eraIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, _) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.firstStarsBg,
          nextBackgroundColor: AppColors.galaxiesBg,
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
                    starCount: 150,
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
  }
}
