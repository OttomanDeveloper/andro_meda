import 'package:safeandromeda/core/hooks/hooks.dart';

/// Draws particles that travel along a velocity vector as the era scrolls,
/// each with a fading trail and glow.
class ParticlePainter extends CustomPainter {
  const ParticlePainter({
    required this.progress,
    required this.particles,
    this.time = 0.0,
  });

  /// Era scroll progress in [0, 1]; drives each particle's lifetime.
  final double progress;

  /// Particle definitions to render.
  final List<Particle> particles;

  /// Global animation clock in seconds; drives ambient jitter.
  final double time;

  /// Draws each live particle with trail, glow halo, and core.
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    for (int i = 0; i < particles.length; i++) {
      final Particle p = particles[i];
      // Age in [0, 1] since this particle's birth point in scroll.
      final double life = (progress - p.birthProgress).clamp(0.0, 1.0);
      if (life <= 0.0) continue;

      // Ambient sinusoidal drift independent of scroll
      final double ambientX = sin(time * 1.0 + i * 1.3) * size.width * 0.003;
      final double ambientY = cos(time * 0.8 + i * 0.9) * size.height * 0.003;

      final double x =
          size.width * p.startX + (p.velocityX * size.width * life) + ambientX;
      final double y =
          size.height * p.startY +
          (p.velocityY * size.height * life) +
          ambientY;

      if (x < -20 || x > size.width + 20 || y < -20 || y > size.height + 20) {
        continue;
      }

      final double fadeIn = (life / 0.1).clamp(0.0, 1.0); // first 10% of life
      final double fadeOut =
          life >
              0.8 // last 20% of life
          ? ((1.0 - life) / 0.2).clamp(0.0, 1.0)
          : 1.0;
      final double opacity = (fadeIn * fadeOut * p.opacity).clamp(0.0, 1.0);
      // Particle grows from half size to full over its life.
      final double currentSize = p.size * (0.5 + life * 0.5);

      // Trail: draw 3 previous positions at decreasing opacity/size
      const double trailStep = 0.03;
      for (int t = 3; t >= 1; t--) {
        final double trailLife = (life - trailStep * t).clamp(0.0, 1.0);
        if (trailLife <= 0.0) continue;
        final double tx =
            size.width * p.startX +
            (p.velocityX * size.width * trailLife) +
            ambientX;
        final double ty =
            size.height * p.startY +
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

  /// Repaints when scroll or clock changes.
  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.time != time;
}

/// One particle: start point, velocity, appearance, and when it is born.
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

  /// Start X as a fraction of canvas width.
  final double startX;

  /// Start Y as a fraction of canvas height.
  final double startY;

  /// Horizontal travel per unit life, as a fraction of canvas width.
  final double velocityX;

  /// Vertical travel per unit life, as a fraction of canvas height.
  final double velocityY;

  /// Particle color, reused for trail and glow.
  final Color color;

  /// Core radius in px at full life.
  final double size;

  /// Peak opacity in [0, 1].
  final double opacity;

  /// Scroll progress at which this particle starts living.
  final double birthProgress;
}
