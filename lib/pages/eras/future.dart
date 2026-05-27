import 'package:safeandromeda/core/hooks/hooks.dart';

class FutureEra extends StatelessWidget {
  const FutureEra({super.key});

  static const int eraIndex = 8;

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
                final double lightProgress = (progress * 1.5).clamp(0.0, 1.0);

                return EraWrapper(
                  eraIndex: eraIndex,
                  backgroundColor: Color.lerp(
                    AppColors.futureBg,
                    AppColors.futureLight,
                    lightProgress,
                  )!,
                  nextBackgroundColor: AppColors.portfolioBg,
                  useDarkText: progress > 0.4,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: StarFieldPainter(
                            progress: progress,
                            time: anim.time,
                            starCount: 100,
                            baseColor: AppColors.white,
                            maxOpacity: (1.0 - lightProgress).clamp(0.0, 0.8),
                            seed: 999,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _FutureTechPainter(
                            progress: progress,
                            lightProgress: lightProgress,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _DataStreamPainter(
                            progress: progress,
                            time: anim.time,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: AppColors.futureLight
                              .withValues(alpha: lightProgress * 0.8),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.futureGlow,
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

class _FutureTechPainter extends CustomPainter {
  const _FutureTechPainter({
    required this.progress,
    required this.lightProgress,
  });

  final double progress;
  final double lightProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    _drawGrid(canvas, w, h);
    _drawAccentLines(canvas, w, h);
    _drawDigitalParticles(canvas, w, h);
  }

  void _drawGrid(Canvas canvas, double w, double h) {
    // Subtle grid pattern that fades in as background lightens
    final double gridOpacity = (lightProgress * 0.05).clamp(0.0, 0.05);
    if (gridOpacity < 0.005) return;

    final bool isDark = lightProgress < 0.5;
    final Color gridColor = isDark
        ? AppColors.white.withValues(alpha: gridOpacity)
        : AppColors.portfolioText.withValues(alpha: gridOpacity);

    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    final double spacing = w * 0.05;

    // Vertical lines
    double x = 0;
    while (x < w) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
      x += spacing;
    }

    // Horizontal lines
    double y = 0;
    while (y < h) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      y += spacing;
    }
  }

  void _drawAccentLines(Canvas canvas, double w, double h) {
    // 3 horizontal neon-blue lines that pulse in opacity
    const List<double> lineYs = [0.3, 0.5, 0.7];
    const Color neonBlue = Color(0xff6496ff);

    for (int i = 0; i < lineYs.length; i++) {
      // Pulse effect: each line pulses at a different phase
      final double pulse = (sin((progress * 6.283 * 2) + i * 2.1) * 0.5 + 0.5);
      final double lineOpacity = (pulse * 0.12 * progress).clamp(0.0, 0.12);

      if (lineOpacity < 0.005) continue;

      final double ly = h * lineYs[i];
      final double lineWidth = w * (0.3 + 0.2 * pulse);
      final double lineX = (w - lineWidth) * 0.5;

      // Glow
      final Paint glowPaint = Paint()
        ..color = neonBlue.withValues(alpha: lineOpacity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10)
        ..strokeWidth = 3;
      canvas.drawLine(
        Offset(lineX, ly),
        Offset(lineX + lineWidth, ly),
        glowPaint,
      );

      // Core line
      final Paint linePaint = Paint()
        ..color = neonBlue.withValues(alpha: lineOpacity)
        ..strokeWidth = 1.0;
      canvas.drawLine(
        Offset(lineX, ly),
        Offset(lineX + lineWidth, ly),
        linePaint,
      );
    }
  }

  void _drawDigitalParticles(Canvas canvas, double w, double h) {
    // Small dot particles drifting upward — digital/energy particles
    const int particleCount = 20;
    const Color particleColor = Color(0xff6496ff);

    for (int i = 0; i < particleCount; i++) {
      final double seed = (i * 137.508) % 100 / 100;
      final double px = w * ((seed * 7 + i * 0.13) % 1.0);
      final double rawY = ((seed * 5 + progress * 1.5 + i * 0.17) % 1.0);
      final double py = h * (1.0 - rawY); // drift upward

      final double particleAlpha = (1.0 - rawY) * progress * 0.3;
      if (particleAlpha < 0.01) continue;

      final bool isDark = lightProgress < 0.5;
      final Color pColor = isDark
          ? particleColor.withValues(alpha: particleAlpha)
          : AppColors.portfolioAccent.withValues(alpha: particleAlpha * 0.6);

      // Glow
      final Paint glowPaint = Paint()
        ..color = pColor.withValues(alpha: particleAlpha * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(px, py), 3, glowPaint);

      // Core dot
      final Paint dotPaint = Paint()..color = pColor;
      canvas.drawCircle(Offset(px, py), 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FutureTechPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      lightProgress != oldDelegate.lightProgress;
}

class _DataStreamPainter extends CustomPainter {
  const _DataStreamPainter({required this.progress, required this.time});
  final double progress;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.1) return;
    final double streamOpacity = ((progress - 0.1) / 0.4).clamp(0.0, 0.15);
    final Paint paint = Paint();
    final Random r = Random(77);

    for (int col = 0; col < 15; col++) {
      final double x = (col / 15) * size.width + r.nextDouble() * 20;
      final double speed = 0.5 + r.nextDouble() * 1.5;

      for (int dot = 0; dot < 20; dot++) {
        final double baseY = size.height - (dot * size.height * 0.05);
        final double y = baseY - ((time * speed * 30) % size.height);
        final double wrappedY = y < 0 ? y + size.height : y;

        final double dotSize = 1 + r.nextDouble() * 2;
        final bool isDash = r.nextDouble() > 0.6;

        paint.color = AppColors.futureGlow
            .withValues(alpha: streamOpacity * (0.5 + r.nextDouble() * 0.5));

        if (isDash) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, wrappedY, dotSize, dotSize * 4),
              const Radius.circular(1),
            ),
            paint,
          );
        } else {
          canvas.drawCircle(Offset(x, wrappedY), dotSize * 0.5, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DataStreamPainter old) =>
      old.progress != progress || old.time != time;
}
