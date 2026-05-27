import 'package:safeandromeda/core/hooks/hooks.dart';

class AgeOfGiantsEra extends StatelessWidget {
  const AgeOfGiantsEra({super.key});

  static const int eraIndex = 6;

  static const List<NebulaCloud> _mist = [
    NebulaCloud(
        x: 0.2,
        y: 0.7,
        radius: 0.3,
        color: AppColors.giantsForest,
        opacity: 0.32,
        driftSpeed: 0.01),
    NebulaCloud(
        x: 0.7,
        y: 0.6,
        radius: 0.25,
        color: AppColors.giantsLeaf,
        opacity: 0.2,
        driftSpeed: -0.008),
    NebulaCloud(
        x: 0.5,
        y: 0.8,
        radius: 0.35,
        color: AppColors.giantsBg,
        opacity: 0.28,
        driftSpeed: 0.005),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

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
                  backgroundColor: AppColors.giantsBg,
                  nextBackgroundColor: AppColors.humanityBg,
                  interactionHint:
                      isMobile ? 'TAP TO REVEAL' : 'HOVER TO REVEAL',
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.giantsBg,
                                AppColors.giantsForest,
                                AppColors.giantsForest,
                              ],
                              stops: [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: NebulaPainter(
                            progress: progress,
                            clouds: _mist,
                            time: anim.time,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _SceneryPainter(
                            progress: progress,
                            time: anim.time,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CreatureRevealer(eraProgress: progress),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _GroundFogPainter(
                            progress: progress,
                            time: anim.time,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.giantsLeaf,
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

class _SceneryPainter extends CustomPainter {
  const _SceneryPainter({required this.progress, required this.time});
  final double progress;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final double sceneOpacity = progress.clamp(0.0, 1.0);
    if (sceneOpacity < 0.05) return;
    final Paint paint = Paint();

    // Mountains in background
    final Path mountains = Path();
    mountains.moveTo(0, size.height * 0.55);
    mountains.lineTo(size.width * 0.1, size.height * 0.35);
    mountains.lineTo(size.width * 0.2, size.height * 0.5);
    mountains.lineTo(size.width * 0.3, size.height * 0.3);
    mountains.lineTo(size.width * 0.42, size.height * 0.48);
    mountains.lineTo(size.width * 0.55, size.height * 0.28);
    mountains.lineTo(size.width * 0.65, size.height * 0.42);
    mountains.lineTo(size.width * 0.75, size.height * 0.32);
    mountains.lineTo(size.width * 0.88, size.height * 0.45);
    mountains.lineTo(size.width, size.height * 0.38);
    mountains.lineTo(size.width, size.height * 0.55);
    mountains.close();

    paint.color = AppColors.giantsBg.withValues(alpha: 0.4 * sceneOpacity);
    canvas.drawPath(mountains, paint);

    // Tree silhouettes along the ground
    final Random r = Random(88);
    for (int i = 0; i < 12; i++) {
      final double tx = (i / 12) * size.width + r.nextDouble() * 30;
      final double groundY = size.height * 0.72;
      final double treeHeight = 30 + r.nextDouble() * 60;
      final double trunkWidth = 3 + r.nextDouble() * 3;
      final double canopyRadius = 10 + r.nextDouble() * 20;

      paint.color = const Color(0xff0a1508).withValues(alpha: 0.5 * sceneOpacity);

      // Trunk
      canvas.drawRect(
        Rect.fromLTWH(tx - trunkWidth / 2, groundY - treeHeight, trunkWidth, treeHeight),
        paint,
      );

      // Canopy (triangle for conifers)
      final Path canopy = Path();
      canopy.moveTo(tx, groundY - treeHeight - canopyRadius);
      canopy.lineTo(tx - canopyRadius, groundY - treeHeight + canopyRadius * 0.4);
      canopy.lineTo(tx + canopyRadius, groundY - treeHeight + canopyRadius * 0.4);
      canopy.close();
      canvas.drawPath(canopy, paint);
    }

    // Flying pterodactyls
    for (int p = 0; p < 3; p++) {
      final double phase = time * (0.15 + p * 0.05) + p * 2.5;
      final double px = (phase % 1.3) * size.width / 1.3;
      final double py = size.height * (0.1 + p * 0.06) + sin(time * 0.8 + p) * 15;
      final double wingSpan = 20 + p * 8.0;
      final double wingFlap = sin(time * 3.0 + p * 1.5) * 8;

      paint.color = const Color(0xff0a1508).withValues(alpha: 0.45 * sceneOpacity);

      final Path ptero = Path();
      ptero.moveTo(px, py);
      ptero.lineTo(px - wingSpan, py - wingFlap);
      ptero.lineTo(px - wingSpan * 0.3, py + 2);
      ptero.lineTo(px + wingSpan * 0.3, py + 2);
      ptero.lineTo(px + wingSpan, py - wingFlap);
      ptero.close();
      canvas.drawPath(ptero, paint);

      // Head
      canvas.drawCircle(Offset(px + wingSpan * 0.15, py - 2), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SceneryPainter old) =>
      old.progress != progress || old.time != time;
}

class _GroundFogPainter extends CustomPainter {
  const _GroundFogPainter({required this.progress, required this.time});
  final double progress;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final double fogProgress = progress.clamp(0.0, 1.0);
    final Paint paint = Paint();
    final double fogTop = size.height * (0.9 - fogProgress * 0.3);

    // Multiple fog layers at slightly different heights
    for (int layer = 0; layer < 4; layer++) {
      final double layerY = fogTop + layer * size.height * 0.05;
      final double layerOpacity = (0.18 + layer * 0.05) * fogProgress;
      final double drift = sin(time * 0.2 + layer) * 30;

      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.giantsForest.withValues(alpha: 0.0),
          AppColors.giantsForest.withValues(alpha: layerOpacity),
          AppColors.giantsBg.withValues(alpha: layerOpacity * 1.5),
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(
          Rect.fromLTWH(0, layerY, size.width, size.height - layerY));

      canvas.drawRect(
        Rect.fromLTWH(
            drift - 30, layerY, size.width + 60, size.height - layerY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GroundFogPainter old) =>
      old.progress != progress || old.time != time;
}
