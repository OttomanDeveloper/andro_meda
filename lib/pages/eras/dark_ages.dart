import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 1: the cosmic Dark Ages. No stars yet, just cooling hydrogen fog.
class DarkAgesEra extends StatelessWidget {
  const DarkAgesEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 1;

  /// Faint hydrogen wisps drifting across the dark canvas.
  static const List<NebulaCloud> _wisps = [
    NebulaCloud(
      x: 0.3,
      y: 0.4,
      radius: 0.15,
      color: AppColors.darkAgesHydrogen,
      opacity: 0.18,
      driftSpeed: 0.02,
    ),
    NebulaCloud(
      x: 0.6,
      y: 0.6,
      radius: 0.12,
      color: AppColors.darkAgesWisp,
      opacity: 0.14,
      driftSpeed: -0.015,
    ),
    NebulaCloud(
      x: 0.8,
      y: 0.3,
      radius: 0.1,
      color: AppColors.darkAgesHydrogen,
      opacity: 0.16,
      driftSpeed: 0.01,
    ),
  ];

  /// Stacks the fog scene; rebuilt every frame via EraScope.
  @override
  Widget build(BuildContext context) {
    final int seedCount = AppSettings.particleCount(
      context,
      desktop: 18,
    ); // density seeds (proto-structures)

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
              backgroundColor: AppColors.darkAgesBg,
              nextBackgroundColor: AppColors.firstStarsBg,
              child: Stack(
                children: [
                  // Layer 0: drifting hydrogen fog.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: NebulaPainter(
                        progress: progress,
                        clouds: _wisps,
                        time: time,
                        cursorX: cursorX,
                        cursorY: cursorY,
                      ),
                    ),
                  ),
                  // Layer 1: density seeds where gravity is gathering matter.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DensitySeedsPainter(
                        progress: progress,
                        time: time,
                        count: seedCount,
                      ),
                    ),
                  ),
                  // Layer 2: typed-out caption reinforcing the long silence.
                  Positioned(
                    bottom: MediaQuery.sizeOf(context).height * 0.12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _TypewriterText(
                        text: '200 million years of silence...',
                        progress: progress,
                        startAt: 0.15,
                        style: GoogleFonts.roboto(
                          color: AppColors.white.withValues(alpha: 0.15),
                          fontSize: MediaQuery.sizeOf(context).height * 0.016,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              color: AppColors.darkAgesWisp.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Layer 3: floating epoch labels.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: InfoLabelPainter(
                        progress: progress,
                        time: time,
                        labels: _darkAgesFacts,
                        glowColor: AppColors.darkAgesWisp,
                      ),
                    ),
                  ),
                  // Top layer: parallax foreground specks that react to the cursor.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ForegroundPainter(
                        time: time,
                        color: AppColors.darkAgesHydrogen,
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

/// Reveals text character by character as scroll progress passes [startAt].
class _TypewriterText extends StatelessWidget {
  const _TypewriterText({
    required this.text,
    required this.progress,
    required this.startAt,
    required this.style,
  });

  final String text; // full string to type out
  final double progress; // this era's scroll progress
  final double startAt; // progress at which typing starts
  final TextStyle style;

  /// Slices [text] to the count of characters earned by current progress.
  @override
  Widget build(BuildContext context) {
    // Type the whole string over the 0.3 of progress after startAt.
    final double typeProgress = ((progress - startAt) / 0.3).clamp(0.0, 1.0);
    final int charCount = (typeProgress * text.length).floor();
    if (charCount <= 0) return const SizedBox();

    return Text(text.substring(0, charCount), style: style);
  }
}

// Periphery positions keep labels legible against the fog. y is a fraction of
// the full (2x viewport) era canvas.
const List<InfoLabel> _darkAgesFacts = [
  InfoLabel('RECOMBINATION COMPLETE', 0.10, 0.14, 0.04),
  InfoLabel('T + 380,000 YEARS', 0.70, 0.18, 0.10),
  InfoLabel('NEUTRAL HYDROGEN FOG', 0.11, 0.30, 0.18),
  InfoLabel('CMB COOLS  3000K -> 60K', 0.62, 0.34, 0.26),
  InfoLabel('GRAVITY GATHERS MATTER', 0.12, 0.50, 0.36),
  InfoLabel('FIRST STRUCTURES SEED', 0.66, 0.56, 0.46),
];
