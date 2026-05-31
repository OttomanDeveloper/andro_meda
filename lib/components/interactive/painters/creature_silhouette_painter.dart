import 'package:safeandromeda/core/hooks/hooks.dart';

/// Draws one dino silhouette: index 0 T-Rex, 1 Argentinosaurus, 2 Triceratops.
class CreatureSilhouettePainter extends CustomPainter {
  const CreatureSilhouettePainter({
    required this.creatureIndex,
    required this.glowColor,
    this.isRevealed = false,
  });

  final int creatureIndex; // which dino shape to draw, 0..2
  final Color glowColor; // outline/glow tint applied once revealed
  final bool isRevealed; // true switches from dim shadow to lit fill

  /// Dispatches to the per-creature drawing routine.
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    switch (creatureIndex) {
      case 0:
        _paintTRex(canvas, w, h);
      case 1:
        _paintArgentinosaurus(canvas, w, h);
      default:
        _paintTriceratops(canvas, w, h);
    }
  }

  /// Renders a creature path: lit fill plus glow when revealed, else dim shadow.
  void _fillShape(Canvas canvas, Path path) {
    if (isRevealed) {
      canvas.drawPath(
        path,
        Paint()
          ..color = glowColor.withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      );
      canvas.drawPath(path, Paint()..color = const Color(0xff0d1a0a));
      canvas.drawPath(
        path,
        Paint()
          ..color = glowColor.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    } else {
      canvas.drawPath(
        path,
        Paint()..color = const Color(0xff080e05).withValues(alpha: 0.7),
      );
    }
  }

  // A tapering pillar leg that drops from `topFrac` to the shared ground line.
  RRect _leg(double w, double h, double xFrac, double topFrac) {
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(w * xFrac, h * topFrac, w * 0.085, h * (0.95 - topFrac)),
      Radius.circular(w * 0.03),
    );
  }

  /// T-Rex: body outline, two hind legs, tiny arm; glowing eye when revealed.
  void _paintTRex(Canvas canvas, double w, double h) {
    final Path p = Path()
      // Tail, back, neck, head, jaws, chest and belly, one smooth outline.
      ..moveTo(w * 0.02, h * 0.46)
      ..cubicTo(w * 0.12, h * 0.42, w * 0.22, h * 0.38, w * 0.32, h * 0.36)
      ..cubicTo(w * 0.42, h * 0.34, w * 0.48, h * 0.345, w * 0.54, h * 0.33)
      ..cubicTo(w * 0.60, h * 0.315, w * 0.62, h * 0.23, w * 0.66, h * 0.17)
      ..cubicTo(w * 0.70, h * 0.12, w * 0.78, h * 0.12, w * 0.86, h * 0.15)
      ..lineTo(w * 0.94, h * 0.18)
      ..lineTo(w * 0.94, h * 0.235)
      ..lineTo(w * 0.76, h * 0.26)
      ..lineTo(w * 0.85, h * 0.30)
      ..lineTo(w * 0.71, h * 0.31)
      ..cubicTo(w * 0.68, h * 0.40, w * 0.66, h * 0.46, w * 0.62, h * 0.52)
      ..cubicTo(w * 0.56, h * 0.58, w * 0.42, h * 0.58, w * 0.30, h * 0.54)
      ..cubicTo(w * 0.18, h * 0.52, w * 0.08, h * 0.50, w * 0.02, h * 0.46)
      ..close()
      // Near hind leg (thick, bent).
      ..moveTo(w * 0.48, h * 0.50)
      ..cubicTo(w * 0.60, h * 0.52, w * 0.63, h * 0.64, w * 0.57, h * 0.72)
      ..lineTo(w * 0.59, h * 0.92)
      ..lineTo(w * 0.71, h * 0.95)
      ..lineTo(w * 0.70, h * 0.88)
      ..lineTo(w * 0.64, h * 0.72)
      ..cubicTo(w * 0.67, h * 0.62, w * 0.58, h * 0.52, w * 0.48, h * 0.50)
      ..close()
      // Far hind leg.
      ..moveTo(w * 0.36, h * 0.52)
      ..cubicTo(w * 0.46, h * 0.56, w * 0.46, h * 0.66, w * 0.42, h * 0.74)
      ..lineTo(w * 0.44, h * 0.90)
      ..lineTo(w * 0.54, h * 0.92)
      ..lineTo(w * 0.53, h * 0.86)
      ..lineTo(w * 0.49, h * 0.74)
      ..cubicTo(w * 0.52, h * 0.64, w * 0.46, h * 0.55, w * 0.36, h * 0.52)
      ..close()
      // Tiny arm.
      ..moveTo(w * 0.60, h * 0.45)
      ..lineTo(w * 0.67, h * 0.49)
      ..lineTo(w * 0.65, h * 0.525)
      ..lineTo(w * 0.59, h * 0.485)
      ..close();
    _fillShape(canvas, p);
    if (isRevealed) {
      // Eye highlight on the head.
      canvas.drawCircle(
        Offset(w * 0.84, h * 0.20),
        2.5,
        Paint()..color = glowColor.withValues(alpha: 0.85),
      );
    }
  }

  /// Argentinosaurus: long-necked sauropod outline over four pillar legs.
  void _paintArgentinosaurus(Canvas canvas, double w, double h) {
    final Path p = Path()
      // Snout and head, up the long neck, over a big barrel back to the tail
      // tip, then under the tail and around the deep belly and throat.
      ..moveTo(w * 0.02, h * 0.14)
      ..cubicTo(w * 0.02, h * 0.05, w * 0.14, h * 0.04, w * 0.15, h * 0.12)
      ..cubicTo(w * 0.26, h * 0.18, w * 0.34, h * 0.30, w * 0.42, h * 0.38)
      ..cubicTo(w * 0.52, h * 0.30, w * 0.66, h * 0.29, w * 0.76, h * 0.36)
      ..cubicTo(w * 0.84, h * 0.32, w * 0.92, h * 0.31, w * 0.99, h * 0.32)
      ..lineTo(w * 0.99, h * 0.37)
      ..cubicTo(w * 0.90, h * 0.40, w * 0.84, h * 0.44, w * 0.80, h * 0.52)
      ..cubicTo(w * 0.80, h * 0.62, w * 0.50, h * 0.67, w * 0.36, h * 0.60)
      ..cubicTo(w * 0.30, h * 0.54, w * 0.27, h * 0.46, w * 0.24, h * 0.38)
      ..cubicTo(w * 0.18, h * 0.28, w * 0.10, h * 0.20, w * 0.07, h * 0.17)
      ..cubicTo(w * 0.04, h * 0.16, w * 0.02, h * 0.16, w * 0.02, h * 0.14)
      ..close()
      // Four pillar legs tucked beneath the barrel torso.
      ..addRRect(_leg(w, h, 0.34, 0.56))
      ..addRRect(_leg(w, h, 0.44, 0.58))
      ..addRRect(_leg(w, h, 0.62, 0.56))
      ..addRRect(_leg(w, h, 0.71, 0.58));
    _fillShape(canvas, p);
    if (isRevealed) {
      // Eye highlight near the snout.
      canvas.drawCircle(
        Offset(w * 0.07, h * 0.11),
        2,
        Paint()..color = glowColor.withValues(alpha: 0.8),
      );
    }
  }

  /// Triceratops: body, frill, two brow horns, nose horn, four stocky legs.
  void _paintTriceratops(Canvas canvas, double w, double h) {
    final Path p = Path()
      // Body: shoulders, back, rump tapering to a short tail, belly, chest.
      ..moveTo(w * 0.34, h * 0.42)
      ..cubicTo(w * 0.50, h * 0.36, w * 0.68, h * 0.37, w * 0.80, h * 0.43)
      ..cubicTo(w * 0.88, h * 0.47, w * 0.96, h * 0.47, w * 0.99, h * 0.49)
      ..lineTo(w * 0.99, h * 0.525)
      ..cubicTo(w * 0.90, h * 0.54, w * 0.86, h * 0.57, w * 0.80, h * 0.61)
      ..cubicTo(w * 0.64, h * 0.66, w * 0.46, h * 0.66, w * 0.36, h * 0.61)
      ..cubicTo(w * 0.30, h * 0.55, w * 0.30, h * 0.47, w * 0.34, h * 0.42)
      ..close()
      // Head and bony frill: a broad plate fanning up and back, then the
      // face dropping to the hooked beak and jaw.
      ..moveTo(w * 0.36, h * 0.44)
      ..cubicTo(w * 0.34, h * 0.24, w * 0.30, h * 0.16, w * 0.22, h * 0.18)
      ..cubicTo(w * 0.14, h * 0.20, w * 0.10, h * 0.28, w * 0.08, h * 0.36)
      ..cubicTo(w * 0.05, h * 0.40, w * 0.02, h * 0.44, w * 0.02, h * 0.48)
      ..cubicTo(w * 0.02, h * 0.53, w * 0.08, h * 0.55, w * 0.14, h * 0.54)
      ..cubicTo(w * 0.24, h * 0.56, w * 0.32, h * 0.54, w * 0.36, h * 0.50)
      ..close()
      // Long brow horn (front), sweeping up over the face.
      ..moveTo(w * 0.10, h * 0.34)
      ..cubicTo(w * 0.06, h * 0.20, w * 0.04, h * 0.10, w * 0.02, h * 0.04)
      ..cubicTo(w * 0.07, h * 0.12, w * 0.12, h * 0.22, w * 0.16, h * 0.32)
      ..close()
      // Second brow horn.
      ..moveTo(w * 0.18, h * 0.32)
      ..cubicTo(w * 0.16, h * 0.18, w * 0.16, h * 0.10, w * 0.17, h * 0.06)
      ..cubicTo(w * 0.21, h * 0.16, w * 0.24, h * 0.24, w * 0.26, h * 0.32)
      ..close()
      // Short nose horn.
      ..moveTo(w * 0.06, h * 0.42)
      ..lineTo(w * 0.0, h * 0.35)
      ..lineTo(w * 0.10, h * 0.42)
      ..close()
      // Four stocky legs.
      ..addRRect(_leg(w, h, 0.34, 0.58))
      ..addRRect(_leg(w, h, 0.44, 0.60))
      ..addRRect(_leg(w, h, 0.60, 0.58))
      ..addRRect(_leg(w, h, 0.69, 0.60));
    _fillShape(canvas, p);
    if (isRevealed) {
      // Eye highlight between the horns and frill.
      canvas.drawCircle(
        Offset(w * 0.16, h * 0.42),
        2,
        Paint()..color = glowColor.withValues(alpha: 0.8),
      );
    }
  }

  /// Repaints only when the shape or its tint changes; reveal toggles handled
  /// by AnimatedScale/opacity in the host widget, not here.
  @override
  bool shouldRepaint(covariant CreatureSilhouettePainter oldDelegate) =>
      creatureIndex != oldDelegate.creatureIndex ||
      glowColor != oldDelegate.glowColor;
}
