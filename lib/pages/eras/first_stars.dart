import 'package:safeandromeda/core/hooks/hooks.dart';

class FirstStarsEra extends StatelessWidget {
  const FirstStarsEra({super.key});

  static const int eraIndex = 2;

  static const List<List<List<double>>> _constellations = [
    // Triangle
    [[0.2, 0.25], [0.28, 0.15], [0.35, 0.28]],
    // Chain
    [[0.55, 0.2], [0.62, 0.25], [0.68, 0.18], [0.75, 0.22]],
    // Arc
    [[0.4, 0.6], [0.48, 0.55], [0.56, 0.58]],
  ];

  @override
  Widget build(BuildContext context) {
    final int starCount = AppSettings.particleCount(context, desktop: 150);

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
                  backgroundColor: AppColors.firstStarsBg,
                  nextBackgroundColor: AppColors.galaxiesBg,
                  interactionHint: 'TAP TO IGNITE STARS',
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.firstStarsBg,
                                AppColors.firstStarsDeep,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: StarFieldPainter(
                            progress: progress,
                            time: anim.time,
                            starCount: starCount,
                            baseColor: AppColors.firstStarsGlow,
                            maxOpacity: progress.clamp(0.0, 1.0),
                            seed: 77,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ConstellationPainter(
                            progress: progress,
                            time: anim.time,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: StarIgniter(eraProgress: progress),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.firstStarsGlow,
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
}

class _ConstellationPainter extends CustomPainter {
  const _ConstellationPainter({required this.progress, required this.time});
  final double progress;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.3) return;
    final double lineOpacity = ((progress - 0.3) / 0.4).clamp(0.0, 0.45);
    final Paint linePaint = Paint()
      ..color = const Color(0xffc8dcff).withValues(alpha: lineOpacity)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    for (final List<List<double>> constellation in FirstStarsEra._constellations) {
      final Path path = Path();
      for (int i = 0; i < constellation.length; i++) {
        final double drawProgress = ((progress - 0.3 - i * 0.05) / 0.3).clamp(0.0, 1.0);
        if (drawProgress <= 0) break;

        final double cx = constellation[i][0] * size.width;
        final double cy = constellation[i][1] * size.height;

        if (i == 0) {
          path.moveTo(cx, cy);
        } else {
          final double prevX = constellation[i - 1][0] * size.width;
          final double prevY = constellation[i - 1][1] * size.height;
          final double x = prevX + (cx - prevX) * drawProgress;
          final double y = prevY + (cy - prevY) * drawProgress;
          path.lineTo(x, y);
        }

        // Bright dot at each star point
        canvas.drawCircle(
          Offset(cx, cy),
          2.5,
          Paint()..color = const Color(0xffc8dcff).withValues(alpha: lineOpacity * 3),
        );
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter old) =>
      old.progress != progress || old.time != time;
}
