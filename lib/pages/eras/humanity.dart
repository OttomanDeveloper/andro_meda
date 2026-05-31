import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 7: humanity. A three-act story from ice-age hunt to the first cities.
class HumanityEra extends StatelessWidget {
  const HumanityEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 7;

  /// Stacks the human-story scene; rebuilt every frame via EraScope.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

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
              backgroundColor: AppColors.humanityBg,
              nextBackgroundColor: AppColors.futureBg,
              child: Stack(
                children: [
                  // Layer 0: faint night-sky star field.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: StarFieldPainter(
                        progress: progress,
                        time: time,
                        starCount: 80,
                        baseColor: AppColors.white,
                        maxOpacity: 0.25,
                        seed: 789,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 1: the three-act story painter.
                  // The three-act story: ice-age hunt, forest ambush, the camp
                  // that becomes a city, each anchored to its own ground line
                  // and revealed as the era scrolls past.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: HumanityStoryPainter(
                        progress: progress,
                        time: time,
                        viewportHeight: size.height,
                      ),
                    ),
                  ),
                  // Layer 2: parallax foreground specks (under the labels here).
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForegroundPainter(
                        time: time,
                        color: AppColors.humanityFire,
                        seed: eraIndex * 100 + 99,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Top layer: floating epoch labels.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: InfoLabelPainter(
                        progress: progress,
                        time: time,
                        glowColor: AppColors.humanityWarm,
                        labels: _humanityFacts,
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

/// Periphery facts, grouped to fade in alongside each of the three dioramas.
const List<InfoLabel> _humanityFacts = [
  // Act 1, ice age.
  InfoLabel('ICE AGE · 115,000–11,700 YEARS AGO', 0.05, 0.305, 0.02),
  InfoLabel('WOOLLY MAMMOTH HERDS', 0.72, 0.30, 0.07),
  InfoLabel('SPEAR HUNTING · 400,000 YEARS AGO', 0.06, 0.40, 0.12),
  // Act 2, forest ambush.
  InfoLabel('PACK HUNTING · STRENGTH IN NUMBERS', 0.05, 0.585, 0.27),
  InfoLabel('SABERTOOTH AMBUSH', 0.74, 0.60, 0.32),
  InfoLabel('STONE-TIPPED SPEARS', 0.07, 0.67, 0.37),
  // Act 3, the camp becomes a city.
  InfoLabel('MASTERY OF FIRE · 1,000,000 YEARS AGO', 0.05, 0.865, 0.55),
  InfoLabel('CAVE PAINTINGS · 40,000 YEARS AGO', 0.72, 0.885, 0.62),
  InfoLabel('FIRST CITIES · 6,000 YEARS AGO', 0.06, 0.935, 0.70),
];
