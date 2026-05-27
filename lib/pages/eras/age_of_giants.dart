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
                              ],
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
