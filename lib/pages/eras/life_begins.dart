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
        opacity: 0.24,
        driftSpeed: 0.02),
    NebulaCloud(
        x: 0.6,
        y: 0.4,
        radius: 0.15,
        color: AppColors.lifeTeal,
        opacity: 0.2,
        driftSpeed: -0.015),
    NebulaCloud(
        x: 0.7,
        y: 0.6,
        radius: 0.18,
        color: AppColors.lifeGreen,
        opacity: 0.18,
        driftSpeed: 0.01),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CursorProvider>(
      builder: (_, CursorProvider cursor, _) {
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
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _DNAHelixPainter(
                            progress: progress,
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
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.lifeGreen,
                            seed: eraIndex * 100 + 99,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
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
      },
    );
  }

  static final List<Particle> _cellParticles = List<Particle>.generate(
    45,
    (int i) {
      final Random r = Random(i + 500);
      return Particle(
        startX: 0.2 + r.nextDouble() * 0.6,
        startY: 0.2 + r.nextDouble() * 0.6,
        velocityX: (r.nextDouble() - 0.5) * 0.12,
        velocityY: (r.nextDouble() - 0.5) * 0.12,
        color: i.isEven ? AppColors.lifeGreen : AppColors.lifeTeal,
        size: 4.0 + r.nextDouble() * 8.0,
        opacity: 0.15 + r.nextDouble() * 0.2,
        birthProgress: r.nextDouble() * 0.4,
      );
    },
  );
}

class _DNAHelixPainter extends CustomPainter {
  const _DNAHelixPainter({required this.progress, required this.time});
  final double progress;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.2) return;
    final double helixOpacity = ((progress - 0.2) / 0.3).clamp(0.0, 0.4);
    final Paint strandPaint = Paint()
      ..color = AppColors.lifeGreen.withValues(alpha: helixOpacity)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    final Paint rungPaint = Paint()
      ..color = AppColors.lifeTeal.withValues(alpha: helixOpacity * 0.8)
      ..strokeWidth = 0.8;

    final double centerX = size.width * 0.7;
    final double startY = size.height * 0.15;
    final double endY = size.height * 0.85;
    final double amplitude = size.width * 0.06;
    const int points = 60;

    final Path strand1 = Path();
    final Path strand2 = Path();

    for (int i = 0; i <= points; i++) {
      final double t = i / points;
      final double y = startY + (endY - startY) * t;
      final double phase = t * pi * 6 + time * 1.5;

      final double x1 = centerX + sin(phase) * amplitude;
      final double x2 = centerX - sin(phase) * amplitude;

      if (i == 0) {
        strand1.moveTo(x1, y);
        strand2.moveTo(x2, y);
      } else {
        strand1.lineTo(x1, y);
        strand2.lineTo(x2, y);
      }

      // Rungs connecting the two strands every 4 points
      if (i % 4 == 0 && i > 0) {
        canvas.drawLine(Offset(x1, y), Offset(x2, y), rungPaint);
      }
    }

    canvas.drawPath(strand1, strandPaint);
    canvas.drawPath(strand2, strandPaint);
  }

  @override
  bool shouldRepaint(covariant _DNAHelixPainter old) =>
      old.progress != progress || old.time != time;
}
