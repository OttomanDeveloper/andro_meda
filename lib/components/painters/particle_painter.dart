import 'package:safeandromeda/core/hooks/hooks.dart';

class ParticlePainter extends CustomPainter {
  const ParticlePainter({
    required this.progress,
    required this.particles,
  });

  final double progress;
  final List<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    for (final Particle p in particles) {
      final double life = (progress - p.birthProgress).clamp(0.0, 1.0);
      if (life <= 0.0) continue;

      final double x =
          size.width * p.startX + (p.velocityX * size.width * life);
      final double y =
          size.height * p.startY + (p.velocityY * size.height * life);

      if (x < -20 ||
          x > size.width + 20 ||
          y < -20 ||
          y > size.height + 20) {
        continue;
      }

      final double fadeIn = (life / 0.1).clamp(0.0, 1.0);
      final double fadeOut =
          life > 0.8 ? ((1.0 - life) / 0.2).clamp(0.0, 1.0) : 1.0;
      final double opacity = (fadeIn * fadeOut * p.opacity).clamp(0.0, 1.0);

      paint.color = p.color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), p.size * (0.5 + life * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class Particle {
  const Particle({
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.color,
    this.size = 1.5,
    this.opacity = 1.0,
    this.birthProgress = 0.0,
  });

  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final Color color;
  final double size;
  final double opacity;
  final double birthProgress;
}
