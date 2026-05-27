import 'package:safeandromeda/core/hooks/hooks.dart';

class BigBangEra extends StatelessWidget {
  const BigBangEra({super.key});

  static const int eraIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, _) {
        final double progress = pro.eraProgressFor(eraIndex);

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.bigBangVoid,
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
                    particles: _bigBangParticles,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static final List<Particle> _bigBangParticles = List<Particle>.generate(
    80,
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
