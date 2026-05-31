import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 4: our Solar System, the Sun with planets on their orbits.
class SolarSystemEra extends StatelessWidget {
  const SolarSystemEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 4;

  /// Stacks the solar system scene; rebuilt every frame via EraScope.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final int starCount = AppSettings.particleCount(
      context,
      desktop: 80,
    ); // sparse background stars

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
              backgroundColor: AppColors.solarBg,
              nextBackgroundColor: AppColors.lifeBg,
              child: Stack(
                children: [
                  // Layer 0: faint background star field.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: StarFieldPainter(
                        progress: progress,
                        time: time,
                        starCount: starCount,
                        baseColor: AppColors.white,
                        maxOpacity: 0.3,
                        seed: 456,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 1: the Sun, orbits, and planets. Needs viewport size for layout.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SolarSystemPainter(
                        progress: progress,
                        time: time,
                        viewportHeight: size.height,
                        viewportWidth: size.width,
                      ),
                    ),
                  ),
                  // Layer 2: floating epoch labels.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: InfoLabelPainter(
                        progress: progress,
                        time: time,
                        labels: _solarFacts,
                        glowColor: AppColors.solarFlare,
                      ),
                    ),
                  ),
                  // Top layer: parallax foreground specks that react to the cursor.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForegroundPainter(
                        time: time,
                        color: AppColors.solarFlare,
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

// Periphery positions keep labels legible beside the centred system. y is a
// fraction of the full (2x viewport) era canvas.
const List<InfoLabel> _solarFacts = [
  InfoLabel('OUR SOLAR SYSTEM', 0.10, 0.14, 0.04),
  InfoLabel('4.6 BILLION YEARS AGO', 0.63, 0.18, 0.12),
  InfoLabel('THE SUN: 99.8% OF ALL MASS', 0.09, 0.30, 0.20),
  InfoLabel('8 PLANETS, 200+ MOONS', 0.63, 0.34, 0.28),
  InfoLabel('ASTEROID BELT', 0.11, 0.50, 0.38),
  InfoLabel('OORT CLOUD COMETS', 0.64, 0.56, 0.48),
];
