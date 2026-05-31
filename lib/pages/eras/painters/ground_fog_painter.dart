import 'package:safeandromeda/core/hooks/hooks.dart';

/// Stacked translucent fog banks hugging the forest floor, each drifting
/// sideways at its own pace. Rises higher as the era scrolls in.
class GroundFogPainter extends CustomPainter {
  const GroundFogPainter({required this.progress, required this.time});
  final double progress; // era scroll progress 0..1, also overall fog alpha
  final double time; // global animation clock, seconds

  /// Draws four gradient bands fading from clear at top to denser at bottom.
  @override
  void paint(Canvas canvas, Size size) {
    final double fogProgress = progress.clamp(0.0, 1.0);
    final Paint paint = Paint();
    // Top of the fog: 0.9h when off, climbing to 0.6h at full progress.
    final double fogTop = size.height * (0.9 - fogProgress * 0.3);

    // Multiple fog layers at slightly different heights
    for (int layer = 0; layer < 4; layer++) {
      final double layerY =
          fogTop + layer * size.height * 0.05; // each layer 5% lower
      final double layerOpacity =
          (0.18 + layer * 0.05) * fogProgress; // lower layers denser
      final double drift =
          sin(time * 0.2 + layer) * 30; // slow horizontal sway, px

      paint.shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.giantsForest.withValues(alpha: 0.0),
              AppColors.giantsForest.withValues(alpha: layerOpacity),
              AppColors.giantsBg.withValues(alpha: layerOpacity * 1.5),
            ],
            stops: const [0.0, 0.3, 1.0],
          ).createShader(
            Rect.fromLTWH(0, layerY, size.width, size.height - layerY),
          );

      canvas.drawRect(
        // Over-wide by 60px so the drift never exposes a bare edge.
        Rect.fromLTWH(
          drift - 30,
          layerY,
          size.width + 60,
          size.height - layerY,
        ),
        paint,
      );
    }
  }

  /// Repaint whenever scroll or the animation clock moves.
  @override
  bool shouldRepaint(covariant GroundFogPainter old) =>
      old.progress != progress || old.time != time;
}
