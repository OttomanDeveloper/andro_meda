import 'package:safeandromeda/core/hooks/hooks.dart';

class LifeBeginsEra extends StatelessWidget {
  const LifeBeginsEra({super.key});

  static const int eraIndex = 5;

  static const List<NebulaCloud> _pools = [
    NebulaCloud(
        x: 0.3,
        y: 0.5,
        radius: 0.2,
        color: AppColors.lifeGreen,
        opacity: 0.12,
        driftSpeed: 0.02),
    NebulaCloud(
        x: 0.6,
        y: 0.4,
        radius: 0.15,
        color: AppColors.lifeTeal,
        opacity: 0.1,
        driftSpeed: -0.015),
    NebulaCloud(
        x: 0.7,
        y: 0.6,
        radius: 0.18,
        color: AppColors.lifeGreen,
        opacity: 0.08,
        driftSpeed: 0.01),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationProvider>(
      builder: (_, AnimationProvider anim, _) {
        return Selector<ScrollProvider, double>(
          selector: (_, ScrollProvider pro) =>
              (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
          builder: (_, double progress, _) {
            return EraWrapper(
              eraIndex: eraIndex,
              backgroundColor: AppColors.lifeBg,
              nextBackgroundColor: AppColors.giantsBg,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: NebulaPainter(
                        progress: progress,
                        clouds: _pools,
                        time: anim.time,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ParticlePainter(
                        progress: progress,
                        particles: _cellParticles,
                        time: anim.time,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static final List<Particle> _cellParticles = List<Particle>.generate(
    30,
    (int i) {
      final Random r = Random(i + 500);
      return Particle(
        startX: 0.2 + r.nextDouble() * 0.6,
        startY: 0.2 + r.nextDouble() * 0.6,
        velocityX: (r.nextDouble() - 0.5) * 0.05,
        velocityY: (r.nextDouble() - 0.5) * 0.05,
        color: i.isEven ? AppColors.lifeGreen : AppColors.lifeTeal,
        size: 2.0 + r.nextDouble() * 4.0,
        opacity: 0.15 + r.nextDouble() * 0.2,
        birthProgress: r.nextDouble() * 0.4,
      );
    },
  );
}
