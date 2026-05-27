import 'package:safeandromeda/core/hooks/hooks.dart';

class OrbitPainter extends CustomPainter {
  const OrbitPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant OrbitPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
