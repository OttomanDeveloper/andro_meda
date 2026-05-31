import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 3: galaxies forming and a spiral the user can drag to rotate.
class GalaxiesEra extends StatelessWidget {
  const GalaxiesEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 3;

  /// Overlapping clouds clustered near center to read as galactic gas.
  static const List<NebulaCloud> _galacticClouds = [
    NebulaCloud(
      x: 0.5,
      y: 0.4,
      radius: 0.25,
      color: AppColors.galaxiesArm,
      opacity: 0.35,
      driftSpeed: 0.03,
    ),
    NebulaCloud(
      x: 0.45,
      y: 0.45,
      radius: 0.18,
      color: AppColors.galaxiesCore,
      opacity: 0.27,
      driftSpeed: -0.02,
    ),
    NebulaCloud(
      x: 0.55,
      y: 0.35,
      radius: 0.2,
      color: AppColors.galaxiesArm,
      opacity: 0.22,
      driftSpeed: 0.025,
    ),
    NebulaCloud(
      x: 0.4,
      y: 0.5,
      radius: 0.15,
      color: AppColors.galaxiesDeep,
      opacity: 0.18,
      driftSpeed: -0.01,
    ),
  ];

  /// Stacks the galaxy scene; rebuilt every frame via EraScope.
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
              backgroundColor: AppColors.galaxiesBg,
              nextBackgroundColor: AppColors.solarBg,
              interactionHint: 'DRAG TO ROTATE',
              child: Stack(
                children: [
                  // Layer 0: distant star field.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: StarFieldPainter(
                        progress: progress,
                        time: time,
                        starCount: starCount,
                        baseColor: AppColors.white,
                        maxOpacity: 0.6,
                        seed: 123,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 1: galactic gas clouds.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: NebulaPainter(
                        progress: progress,
                        clouds: _galacticClouds,
                        time: time,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 2: small galaxies drifting in the background.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DriftingGalaxiesPainter(
                        progress: progress,
                        time: time,
                      ),
                    ),
                  ),
                  // Layer 3: the hero spiral, drag to rotate.
                  Positioned.fill(child: GalaxyRotator(eraProgress: progress)),
                  // Layer 4: bursts of new star birth in the arms.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: StarBirthPainter(progress: progress, time: time),
                    ),
                  ),
                  // Layer 5: floating epoch labels.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: InfoLabelPainter(
                        progress: progress,
                        time: time,
                        labels: _galaxiesFacts,
                        glowColor: AppColors.galaxiesArm,
                      ),
                    ),
                  ),
                  // Top layer: parallax foreground specks that react to the cursor.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForegroundPainter(
                        time: time,
                        color: AppColors.galaxiesArm,
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

// Periphery positions keep labels legible against the field. y is a fraction of
// the full (2x viewport) era canvas.
const List<InfoLabel> _galaxiesFacts = [
  InfoLabel('GALAXIES FORM', 0.10, 0.14, 0.04),
  InfoLabel('10 BILLION YEARS AGO', 0.62, 0.18, 0.12),
  InfoLabel('DARK MATTER HALOS', 0.11, 0.30, 0.20),
  InfoLabel('GALAXY MERGERS', 0.62, 0.34, 0.28),
  InfoLabel('SPIRAL ARMS WIND UP', 0.10, 0.50, 0.38),
  InfoLabel('BILLIONS OF STARS EACH', 0.62, 0.56, 0.48),
];
