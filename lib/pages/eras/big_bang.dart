import 'package:safeandromeda/core/hooks/hooks.dart';

/// Era 0: the Big Bang. A central flash erupts and matter streams outward.
class BigBangEra extends StatelessWidget {
  const BigBangEra({super.key});

  /// Slot in the timeline; ties this era to its scroll range and colors.
  static const int eraIndex = 0;

  /// Stacks the explosion scene; rebuilt every frame via EraScope.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final int count = AppSettings.particleCount(
      context,
      desktop: 80,
    ); // ejecta particles
    final int dustCount = AppSettings.particleCount(
      context,
      desktop: 70,
    ); // background dust grains

    return EraScope(
      eraIndex: eraIndex,
      builder: (BuildContext context, double time, double progress, double cursorX, double cursorY) {
        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.bigBangVoid,
          nextBackgroundColor: AppColors.darkAgesBg,
          child: Stack(
            children: [
              // Layer 0: radial gradient flash that grows and fades out as the era plays.
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius:
                          0.05 +
                          progress * 2.5, // gradient spreads as scroll advances
                      colors: [
                        AppColors.bigBangCenter.withValues(
                          alpha: (1.0 - progress).clamp(0.0, 0.9),
                        ),
                        AppColors.bigBangMid.withValues(
                          alpha: (0.6 - progress * 0.6).clamp(0.0, 0.6),
                        ),
                        AppColors.bigBangOuter.withValues(
                          alpha: (0.3 - progress * 0.3).clamp(0.0, 0.3),
                        ),
                        AppColors.bigBangVoid,
                      ],
                      stops: const [0.0, 0.2, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Layer 1: concentric rings rippling out from the origin.
              Positioned.fill(
                child: CustomPaint(
                  painter: ExpandingRingsPainter(
                    progress: progress,
                    time: time,
                  ),
                ),
              ),
              // Layer 2: the singularity core, a glowing circle that swells then dims.
              Positioned.fill(
                child: Center(
                  child: Container(
                    width:
                        size.width *
                        (0.02 + progress * 0.8), // grows with scroll
                    height: size.width * (0.02 + progress * 0.8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          // Glow ramps up over the first 20% of scroll, then fades.
                          color: AppColors.bigBangCenter.withValues(
                            alpha: (progress < 0.2)
                                ? (progress / 0.2) * 0.8
                                : (0.8 - (progress - 0.2) * 1.0).clamp(
                                    0.0,
                                    0.8,
                                  ),
                          ),
                          blurRadius: 200 + progress * 400,
                          spreadRadius: progress * 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Layer 3: expanding shockwave front.
              Positioned.fill(
                child: CustomPaint(
                  painter: ShockwavePainter(progress: progress, time: time),
                ),
              ),
              // Layer 4: radial light streaks shooting from center.
              Positioned.fill(
                child: CustomPaint(
                  painter: RadialStreakPainter(progress: progress, time: time),
                ),
              ),
              // Layer 5: drifting dust filling the void behind the ejecta.
              Positioned.fill(
                child: CustomPaint(
                  painter: CosmicDustPainter(
                    progress: progress,
                    time: time,
                    count: dustCount,
                  ),
                ),
              ),
              // Layer 6: the ejecta particles flung outward from the origin.
              Positioned.fill(
                child: CustomPaint(
                  painter: ParticlePainter(
                    progress: progress,
                    particles: _generateParticles(count),
                    time: time,
                  ),
                ),
              ),
              // Layer 7: floating epoch labels.
              Positioned.fill(
                child: CustomPaint(
                  painter: InfoLabelPainter(
                    progress: progress,
                    time: time,
                    labels: _bigBangFacts,
                    glowColor: AppColors.bigBangCenter,
                  ),
                ),
              ),
              // Scroll prompt; only on the opening era, fades out fast as you scroll.
              Positioned(
                bottom: size.height * 0.08,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: (1.0 - progress * 4).clamp(0.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SCROLL TO EXPLORE',
                        style: GoogleFonts.roboto(
                          color: AppColors.white.withValues(alpha: 0.35),
                          fontSize: size.height * 0.012,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.white.withValues(alpha: 0.25),
                        size: size.height * 0.025,
                      ),
                    ],
                  ),
                ),
              ),
              // Top layer: parallax foreground specks that react to the cursor.
              Positioned.fill(
                child: CustomPaint(
                  painter: ForegroundPainter(
                    time: time,
                    color: AppColors.bigBangOuter,
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

  /// Builds the ejecta: particles launched in all directions from one point.
  /// Seeded by index so positions stay stable across rebuilds.
  static List<Particle> _generateParticles(int count) {
    return List<Particle>.generate(count, (int i) {
      final Random r = Random(i);
      final double angle = r.nextDouble() * pi * 2; // random outward direction
      final double speed = 0.2 + r.nextDouble() * 0.8; // varied travel rate
      return Particle(
        startX: 0.5,
        startY: 0.4, // origin sits slightly above center
        velocityX: cos(angle) * speed,
        velocityY: sin(angle) * speed,
        color: Color.lerp(
          AppColors.bigBangCenter,
          AppColors.bigBangOuter,
          r.nextDouble(),
        )!,
        size: 1.5 + r.nextDouble() * 3.5,
        birthProgress: r.nextDouble() * 0.3,
      );
    });
  }
}

// Positions hug the left/right edges so labels stay in the dark periphery and
// never wash out against the central explosion. x in [0, 1], y as a fraction of
// the full (2x viewport) era canvas.
const List<InfoLabel> _bigBangFacts = [
  InfoLabel('PLANCK EPOCH', 0.10, 0.13, 0.03),
  InfoLabel('T + 10^-43 s', 0.74, 0.16, 0.08),
  InfoLabel('10^32 KELVIN', 0.11, 0.30, 0.14),
  InfoLabel('INFLATION  x10^50', 0.72, 0.34, 0.22),
  InfoLabel('QUARK-GLUON PLASMA', 0.10, 0.52, 0.32),
  InfoLabel('SPACE ITSELF EXPANDS', 0.66, 0.60, 0.42),
];
