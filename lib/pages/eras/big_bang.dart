import 'package:safeandromeda/core/hooks/hooks.dart';

class BigBangEra extends StatelessWidget {
  const BigBangEra({super.key});

  static const int eraIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final int count = AppSettings.particleCount(context, desktop: 80);

    return Selector<ScrollProvider, double>(
      selector: (_, ScrollProvider pro) =>
          (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
      builder: (_, double progress, _) {

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.bigBangVoid,
          nextBackgroundColor: AppColors.darkAgesBg,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.1 + progress * 1.5,
                      colors: [
                        AppColors.bigBangCenter.withValues(
                            alpha: (1.0 - progress).clamp(0.0, 0.8)),
                        AppColors.bigBangMid.withValues(
                            alpha: (0.6 - progress * 0.6).clamp(0.0, 0.6)),
                        AppColors.bigBangOuter.withValues(
                            alpha: (0.3 - progress * 0.3).clamp(0.0, 0.3)),
                        AppColors.bigBangVoid,
                      ],
                      stops: const [0.0, 0.2, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: ParticlePainter(
                    progress: progress,
                    particles: _generateParticles(count),
                  ),
                ),
              ),
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
            ],
          ),
        );
      },
    );
  }

  static List<Particle> _generateParticles(int count) {
    return List<Particle>.generate(
      count,
      (int i) {
        final Random r = Random(i);
        final double angle = r.nextDouble() * pi * 2;
        final double speed = 0.1 + r.nextDouble() * 0.4;
        return Particle(
          startX: 0.5,
          startY: 0.4,
          velocityX: cos(angle) * speed,
          velocityY: sin(angle) * speed,
          color: Color.lerp(
            AppColors.bigBangCenter,
            AppColors.bigBangOuter,
            r.nextDouble(),
          )!,
          size: 1.0 + r.nextDouble() * 2.5,
          birthProgress: r.nextDouble() * 0.3,
        );
      },
    );
  }
}
