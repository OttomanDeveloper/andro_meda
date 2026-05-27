import 'package:safeandromeda/core/hooks/hooks.dart';

class BigBangEra extends StatelessWidget {
  const BigBangEra({super.key});

  static const int eraIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final int count = AppSettings.particleCount(context, desktop: 80);

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
                  backgroundColor: AppColors.bigBangVoid,
                  nextBackgroundColor: AppColors.darkAgesBg,
                  child: Stack(
                    children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.05 + progress * 2.5,
                          colors: [
                            AppColors.bigBangCenter.withValues(
                                alpha: (1.0 - progress).clamp(0.0, 0.9)),
                            AppColors.bigBangMid.withValues(
                                alpha:
                                    (0.6 - progress * 0.6).clamp(0.0, 0.6)),
                            AppColors.bigBangOuter.withValues(
                                alpha:
                                    (0.3 - progress * 0.3).clamp(0.0, 0.3)),
                            AppColors.bigBangVoid,
                          ],
                          stops: const [0.0, 0.2, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: size.width * (0.02 + progress * 0.8),
                        height: size.width * (0.02 + progress * 0.8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.bigBangCenter.withValues(
                                alpha: (progress < 0.2)
                                    ? (progress / 0.2) * 0.8
                                    : (0.8 - (progress - 0.2) * 1.0)
                                        .clamp(0.0, 0.8),
                              ),
                              blurRadius: 200 + progress * 400,
                              spreadRadius: progress * 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ShockwavePainter(
                        progress: progress,
                        time: anim.time,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RadialStreakPainter(
                        progress: progress,
                        time: anim.time,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ParticlePainter(
                        progress: progress,
                        particles: _generateParticles(count),
                        time: anim.time,
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
                              color:
                                  AppColors.white.withValues(alpha: 0.35),
                              fontSize: size.height * 0.012,
                              letterSpacing: 4,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color:
                                AppColors.white.withValues(alpha: 0.25),
                            size: size.height * 0.025,
                          ),
                        ],
                      ),
                    ),
                  ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.bigBangOuter,
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

  static List<Particle> _generateParticles(int count) {
    return List<Particle>.generate(
      count,
      (int i) {
        final Random r = Random(i);
        final double angle = r.nextDouble() * pi * 2;
        final double speed = 0.2 + r.nextDouble() * 0.8;
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
          size: 1.5 + r.nextDouble() * 3.5,
          birthProgress: r.nextDouble() * 0.3,
        );
      },
    );
  }
}

class _ShockwavePainter extends CustomPainter {
  const _ShockwavePainter({required this.progress, required this.time});
  final double progress;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.02 || progress > 0.5) return;
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final double ringDelay = i * 0.06;
      final double ringProgress =
          ((progress - 0.02 - ringDelay) / 0.3).clamp(0.0, 1.0);
      if (ringProgress <= 0) continue;

      final double radius = ringProgress * size.width * 0.7;
      final double opacity = ((1.0 - ringProgress) * 0.6).clamp(0.0, 0.6);

      paint.color = AppColors.bigBangMid.withValues(alpha: opacity);
      paint.maskFilter =
          MaskFilter.blur(BlurStyle.normal, 3 + ringProgress * 10);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShockwavePainter old) =>
      old.progress != progress;
}

class _RadialStreakPainter extends CustomPainter {
  const _RadialStreakPainter({required this.progress, required this.time});

  final double progress;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.05) return;
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final Paint paint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final double angle = (i / 8) * pi * 2 + time * 0.1;
      final double length = progress * size.width * 0.4;
      final double startDist = progress * 20;

      final double alpha =
          ((0.3 - progress * 0.3) * (0.7 + 0.3 * sin(time + i.toDouble())))
              .clamp(0.0, 0.3);
      paint.color = AppColors.bigBangMid.withValues(alpha: alpha);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawLine(
        Offset(
          center.dx + cos(angle) * startDist,
          center.dy + sin(angle) * startDist,
        ),
        Offset(
          center.dx + cos(angle) * length,
          center.dy + sin(angle) * length,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadialStreakPainter old) =>
      old.progress != progress || old.time != time;
}
