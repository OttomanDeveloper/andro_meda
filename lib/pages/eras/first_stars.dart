import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 2: the first stars igniting and lighting up the universe.
class FirstStarsEra extends StatelessWidget {
  const FirstStarsEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 2;

  // Hero stars: [x, y, size, appearAtProgress]
  static const List<List<double>> _heroStars = [
    [0.15, 0.2, 8.0, 0.1],
    [0.5, 0.15, 10.0, 0.15],
    [0.8, 0.25, 7.0, 0.2],
    [0.35, 0.65, 9.0, 0.25],
    [0.7, 0.55, 8.0, 0.3],
  ];

  /// Stacks the star field plus blooming hero stars; rebuilt every frame.
  @override
  Widget build(BuildContext context) {
    final int starCount = AppSettings.particleCount(
      context,
      desktop: 200,
    ); // background field density

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
            return EraWrapper(
              eraIndex: eraIndex,
              backgroundColor: AppColors.firstStarsBg,
              nextBackgroundColor: AppColors.galaxiesBg,
              interactionHint: 'TAP TO IGNITE STARS',
              child: Stack(
                children: [
                  // Layer 0: vertical gradient backdrop.
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
                  // Layer 1: twinkling star field; fades in with progress.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: StarFieldPainter(
                        progress: progress,
                        time: time,
                        starCount: starCount,
                        baseColor: AppColors.firstStarsGlow,
                        maxOpacity: progress.clamp(0.0, 1.0),
                        seed: 77,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 2: faint constellation lines joining stars.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ConstellationPainter(
                        progress: progress,
                        time: time,
                      ),
                    ),
                  ),
                  // Layer 3: hero stars, large stars that bloom in one at a time.
                  for (int i = 0; i < _heroStars.length; i++)
                    Builder(
                      builder: (_) {
                        final List<double> star = _heroStars[i];
                        // Fade in over 0.15 of progress once past this star's appearAt.
                        final double starOpacity = ((progress - star[3]) / 0.15)
                            .clamp(0.0, 1.0);
                        if (starOpacity <= 0) return const SizedBox.shrink();
                        final Size screenSize = MediaQuery.sizeOf(context);
                        return Positioned(
                          // Center the glow on its fractional canvas position.
                          left: star[0] * screenSize.width - star[2] * 3,
                          top:
                              star[1] *
                                  screenSize.height *
                                  AppSettings
                                      .eraHeightFactor - // canvas is 2x viewport tall
                              star[2] * 3,
                          child: Opacity(
                            opacity: starOpacity,
                            child: Container(
                              width: star[2] * 6,
                              height: star[2] * 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xffc8dcff,
                                ).withValues(alpha: starOpacity * 0.9),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xffc8dcff,
                                    ).withValues(alpha: starOpacity * 0.6),
                                    blurRadius: 40 * starOpacity,
                                    spreadRadius: 10 * starOpacity,
                                  ),
                                  BoxShadow(
                                    color: AppColors.white.withValues(
                                      alpha: starOpacity * 0.3,
                                    ),
                                    blurRadius: 60 * starOpacity,
                                    spreadRadius: 20 * starOpacity,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  // Layer 4: tap interaction that ignites new stars.
                  Positioned.fill(child: StarIgniter(eraProgress: progress)),
                  // Layer 5: supernova flashes seeding heavy elements.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SupernovaePainter(
                        progress: progress,
                        time: time,
                      ),
                    ),
                  ),
                  // Layer 6: floating epoch labels.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: InfoLabelPainter(
                        progress: progress,
                        time: time,
                        labels: _firstStarsFacts,
                        glowColor: AppColors.firstStarsGlow,
                      ),
                    ),
                  ),
                  // Top layer: parallax foreground specks that react to the cursor.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForegroundPainter(
                        time: time,
                        color: AppColors.firstStarsGlow,
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

// Periphery positions keep labels legible against the star field. y is a
// fraction of the full (2x viewport) era canvas.
const List<InfoLabel> _firstStarsFacts = [
  InfoLabel('FIRST LIGHT', 0.10, 0.13, 0.04),
  InfoLabel('POPULATION III STARS', 0.60, 0.17, 0.12),
  InfoLabel('100-1000x SOLAR MASS', 0.11, 0.30, 0.20),
  InfoLabel('FUSION FORGES HELIUM', 0.62, 0.34, 0.28),
  InfoLabel('SUPERNOVAE SEED METALS', 0.10, 0.50, 0.38),
  InfoLabel('REIONIZATION BEGINS', 0.62, 0.56, 0.48),
];
