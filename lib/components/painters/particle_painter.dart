import 'package:safeandromeda/core/hooks/hooks.dart';

class ParticlePainter extends CustomPainter {
  const ParticlePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
