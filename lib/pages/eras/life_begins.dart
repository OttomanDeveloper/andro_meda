import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 5: life begins. Primordial pools, drifting cells, and a DNA helix.
class LifeBeginsEra extends StatelessWidget {
  const LifeBeginsEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 5;

  /// Green and teal clouds reading as primordial soup pools.
  static const List<NebulaCloud> _pools = [
    NebulaCloud(
      x: 0.3,
      y: 0.5,
      radius: 0.2,
      color: AppColors.lifeGreen,
      opacity: 0.24,
      driftSpeed: 0.02,
    ),
    NebulaCloud(
      x: 0.6,
      y: 0.4,
      radius: 0.15,
      color: AppColors.lifeTeal,
      opacity: 0.2,
      driftSpeed: -0.015,
    ),
    NebulaCloud(
      x: 0.7,
      y: 0.6,
      radius: 0.18,
      color: AppColors.lifeGreen,
      opacity: 0.18,
      driftSpeed: 0.01,
    ),
  ];

  /// Stacks the primordial scene; rebuilt every frame via EraScope.
  @override
  Widget build(BuildContext context) {
    final int microbeCount = AppSettings.particleCount(
      context,
      desktop: 26,
    ); // wriggling microbes

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
              backgroundColor: AppColors.lifeBg,
              nextBackgroundColor: AppColors.giantsBg,
              child: Stack(
                children: [
                  // Layer 0: soupy pool clouds.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: NebulaPainter(
                        progress: progress,
                        clouds: _pools,
                        time: time,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 1: the DNA double helix.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DNAHelixPainter(progress: progress, time: time),
                    ),
                  ),
                  // Layer 2: drifting cell blobs.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ParticlePainter(
                        progress: progress,
                        particles: _cellParticles,
                        time: time,
                      ),
                    ),
                  ),
                  // Layer 3: animated microbes.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MicrobesPainter(
                        progress: progress,
                        time: time,
                        count: microbeCount,
                      ),
                    ),
                  ),
                  // Layer 4: floating epoch labels.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: InfoLabelPainter(
                        progress: progress,
                        time: time,
                        labels: _lifeFacts,
                        glowColor: AppColors.lifeTeal,
                      ),
                    ),
                  ),
                  // Top layer: parallax foreground specks that react to the cursor.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForegroundPainter(
                        time: time,
                        color: AppColors.lifeGreen,
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

  /// 45 slow-drifting cell blobs, alternating green/teal. Seed offset keeps
  /// them distinct from other eras' particle sets.
  static final List<Particle> _cellParticles = List<Particle>.generate(45, (
    int i,
  ) {
    final Random r = Random(i + 500);
    return Particle(
      startX:
          0.2 +
          r.nextDouble() * 0.6, // kept within the middle 60% of the canvas
      startY: 0.2 + r.nextDouble() * 0.6,
      velocityX: (r.nextDouble() - 0.5) * 0.12, // gentle drift either direction
      velocityY: (r.nextDouble() - 0.5) * 0.12,
      color: i.isEven ? AppColors.lifeGreen : AppColors.lifeTeal,
      size: 4.0 + r.nextDouble() * 8.0,
      opacity: 0.15 + r.nextDouble() * 0.2,
      birthProgress: r.nextDouble() * 0.4,
    );
  });
}

// Periphery positions keep labels legible against the soup. y is a fraction of
// the full (2x viewport) era canvas.
const List<InfoLabel> _lifeFacts = [
  InfoLabel('LIFE BEGINS', 0.10, 0.14, 0.04),
  InfoLabel('3.8 BILLION YEARS AGO', 0.62, 0.18, 0.12),
  InfoLabel('PRIMORDIAL SOUP', 0.11, 0.30, 0.20),
  InfoLabel('FIRST SINGLE-CELLED LIFE', 0.58, 0.34, 0.28),
  InfoLabel('PROKARYOTES & BACTERIA', 0.10, 0.50, 0.38),
  InfoLabel('CYANOBACTERIA MAKE OXYGEN', 0.55, 0.56, 0.48),
];
