import 'package:safeandromeda/core/hooks/hooks.dart';

class ParticlePainter extends CustomPainter {
  const ParticlePainter({
    required this.progress,
    required this.particles,
    this.time = 0.0,
  });

  final double progress;
  final List<Particle> particles;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    for (int i = 0; i < particles.length; i++) {
      final Particle p = particles[i];
      final double life = (progress - p.birthProgress).clamp(0.0, 1.0);
      if (life <= 0.0) continue;

      // Ambient sinusoidal drift independent of scroll
      final double ambientX = sin(time * 0.5 + i * 1.3) * size.width * 0.003;
      final double ambientY = cos(time * 0.4 + i * 0.9) * size.height * 0.003;

      final double x =
          size.width * p.startX + (p.velocityX * size.width * life) + ambientX;
      final double y = size.height * p.startY +
          (p.velocityY * size.height * life) +
          ambientY;

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
      final double currentSize = p.size * (0.5 + life * 0.5);

      // Trail: draw 3 previous positions at decreasing opacity/size
      const double trailStep = 0.03;
      for (int t = 3; t >= 1; t--) {
        final double trailLife = (life - trailStep * t).clamp(0.0, 1.0);
        if (trailLife <= 0.0) continue;
        final double tx = size.width * p.startX +
            (p.velocityX * size.width * trailLife) +
            ambientX;
        final double ty = size.height * p.startY +
            (p.velocityY * size.height * trailLife) +
            ambientY;
        final double trailOpacity = opacity * (0.3 / t);
        final double trailSize = currentSize * (1.0 - t * 0.2);
        if (trailSize <= 0) continue;
        paint.color = p.color.withValues(alpha: trailOpacity);
        paint.maskFilter = null;
        canvas.drawCircle(Offset(tx, ty), trailSize, paint);
      }

      // Glow halo (2x radius)
      paint.color = p.color.withValues(alpha: opacity * 0.5);
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, currentSize);
      canvas.drawCircle(Offset(x, y), currentSize * 2, paint);

      // Core particle
      paint.color = p.color.withValues(alpha: opacity);
      paint.maskFilter = null;
      canvas.drawCircle(Offset(x, y), currentSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.time != time;
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
