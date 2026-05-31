import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 8: the future. Tech imagery that whites out into the portfolio hand-off.
class FutureEra extends StatelessWidget {
  const FutureEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 8;

  /// Stacks the future scene and drives the white-out transition.
  @override
  Widget build(BuildContext context) {
    return EraScope(
      eraIndex: eraIndex,
      builder:
          (
            BuildContext context,
            double time,
            double progress,
            double cursorX,
            double cursorY,
          ) {
            // Reach full white at ~67% scroll so the portfolio fades in early.
            final double lightProgress = (progress * 1.5).clamp(0.0, 1.0);

            return EraWrapper(
              eraIndex: eraIndex,
              backgroundColor: Color.lerp(
                AppColors.futureBg,
                AppColors.futureLight,
                lightProgress,
              )!,
              nextBackgroundColor: AppColors.portfolioBg,
              useDarkText:
                  progress >
                  0.4, // switch UI text dark once the scene brightens
              child: Stack(
                children: [
                  // Layer 0: star field that fades out as the scene whites out.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: StarFieldPainter(
                        progress: progress,
                        time: time,
                        starCount: 100,
                        baseColor: AppColors.white,
                        maxOpacity: (1.0 - lightProgress).clamp(0.0, 0.8),
                        seed: 999,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 1: futuristic tech imagery.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: FutureTechPainter(
                        progress: progress,
                        lightProgress: lightProgress,
                      ),
                    ),
                  ),
                  // Layer 2: flowing data streams.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DataStreamPainter(
                        progress: progress,
                        time: time,
                      ),
                    ),
                  ),
                  // Layer 3: white wash that ramps up to hand off to the portfolio.
                  Positioned.fill(
                    child: Container(
                      color: AppColors.futureLight.withValues(
                        alpha: lightProgress * 0.8,
                      ),
                    ),
                  ),
                  // Top layer: parallax foreground specks that react to the cursor.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForegroundPainter(
                        time: time,
                        color: AppColors.futureGlow,
                        seed: eraIndex * 100 + 99,
                        cursorX: cursorX,
                        cursorY: cursorY,
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
