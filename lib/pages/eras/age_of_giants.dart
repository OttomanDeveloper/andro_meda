import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 6: the age of dinosaurs. A fern forest with creatures to reveal.
class AgeOfGiantsEra extends StatelessWidget {
  const AgeOfGiantsEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 6;

  /// Low forest mist; weighted to the bottom of the canvas.
  static const List<NebulaCloud> _mist = [
    NebulaCloud(
      x: 0.2,
      y: 0.7,
      radius: 0.3,
      color: AppColors.giantsForest,
      opacity: 0.32,
      driftSpeed: 0.01,
    ),
    NebulaCloud(
      x: 0.7,
      y: 0.6,
      radius: 0.25,
      color: AppColors.giantsLeaf,
      opacity: 0.2,
      driftSpeed: -0.008,
    ),
    NebulaCloud(
      x: 0.5,
      y: 0.8,
      radius: 0.35,
      color: AppColors.giantsBg,
      opacity: 0.28,
      driftSpeed: 0.005,
    ),
  ];

  /// Stacks the forest scene; rebuilt every frame via EraScope.
  @override
  Widget build(BuildContext context) {
    final bool isTouch = Responsive.isTouch(
      context,
    ); // picks tap vs hover hint copy
    final int fishCount = AppSettings.particleCount(
      context,
      desktop: 14,
    ); // fish in the river

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
              backgroundColor: AppColors.giantsBg,
              nextBackgroundColor: AppColors.humanityBg,
              interactionHint: isTouch ? 'TAP TO REVEAL' : 'HOVER TO REVEAL',
              child: Stack(
                children: [
                  // Layer 0: sky-to-forest vertical gradient backdrop.
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.giantsBg,
                            AppColors.giantsForest,
                            AppColors.giantsForest,
                          ],
                          stops: [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Layer 1: low forest mist.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: NebulaPainter(
                        progress: progress,
                        clouds: _mist,
                        time: time,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 2: background scenery (hills, distant trees).
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SceneryPainter(progress: progress, time: time),
                    ),
                  ),
                  // Layer 3: dinosaur silhouettes.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DinosPainter(progress: progress, time: time),
                    ),
                  ),
                  // Layer 4: pterodactyls and other flyers crossing the sky.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForestFliersPainter(
                        progress: progress,
                        time: time,
                      ),
                    ),
                  ),
                  // Layer 5: the river running through the scene.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: RiverPainter(progress: progress, time: time),
                    ),
                  ),
                  // Layer 6: fish in the river.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: FishPainter(
                        progress: progress,
                        time: time,
                        count: fishCount,
                      ),
                    ),
                  ),
                  // Layer 7: hover/tap interaction that uncovers hidden creatures.
                  Positioned.fill(
                    child: CreatureRevealer(eraProgress: progress, time: time),
                  ),
                  // Layer 8: ground fog drifting over the forest floor.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GroundFogPainter(progress: progress, time: time),
                    ),
                  ),
                  // Layer 9: foreground trees swaying in the wind.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WindTreesPainter(progress: progress, time: time),
                    ),
                  ),
                  // Layer 10: floating epoch labels.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: InfoLabelPainter(
                        progress: progress,
                        time: time,
                        labels: _giantsFacts,
                        glowColor: AppColors.giantsLeaf,
                      ),
                    ),
                  ),
                  // Top layer: parallax foreground specks that react to the cursor.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForegroundPainter(
                        time: time,
                        color: AppColors.giantsLeaf,
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

// Periphery positions keep labels legible above the forest. y is a fraction of
// the full (2x viewport) era canvas.
const List<InfoLabel> _giantsFacts = [
  InfoLabel('AGE OF DINOSAURS', 0.10, 0.14, 0.04),
  InfoLabel('230 MILLION YEARS AGO', 0.62, 0.18, 0.12),
  InfoLabel('THE MESOZOIC ERA', 0.11, 0.30, 0.20),
  InfoLabel('GIANT SAUROPODS ROAM', 0.60, 0.34, 0.28),
  InfoLabel('LUSH FERN FORESTS', 0.10, 0.50, 0.38),
  InfoLabel('THEY RULED 165M YEARS', 0.58, 0.56, 0.48),
];
