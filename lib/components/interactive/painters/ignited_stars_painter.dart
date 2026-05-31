import 'package:safeandromeda/core/hooks/hooks.dart';

/// Draws each user-ignited star as a bright core inside two soft halos.
class IgnitedStarsPainter extends CustomPainter {
  const IgnitedStarsPainter({
    required this.stars,
    required this.sizes,
    required this.progress,
  });

  final List<Offset> stars; // tap positions, parallel to sizes
  final List<double> sizes; // core radius per star, px
  final double progress; // era scroll progress, 0..1

  /// Paints all ignited stars; index i in stars pairs with index i in sizes.
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    for (int i = 0; i < stars.length; i++) {
      final Offset pos = stars[i];
      final double starSize = sizes[i];

      // Solid core.
      paint.color = AppColors.firstStarsGlow;
      canvas.drawCircle(pos, starSize, paint);

      // Inner halo, 3x core radius.
      paint.color = AppColors.firstStarsBright.withValues(alpha: 0.3);
      canvas.drawCircle(pos, starSize * 3, paint);

      // Outer halo, 6x core radius.
      paint.color = AppColors.firstStarsGlow.withValues(alpha: 0.1);
      canvas.drawCircle(pos, starSize * 6, paint);
    }
  }

  /// Repaints when a star is added or the era progress changes.
  @override
  bool shouldRepaint(covariant IgnitedStarsPainter oldDelegate) =>
      oldDelegate.stars.length != stars.length ||
      oldDelegate.progress != progress;
}
