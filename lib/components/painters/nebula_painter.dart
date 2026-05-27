import 'package:safeandromeda/core/hooks/hooks.dart';

class NebulaPainter extends CustomPainter {
  const NebulaPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant NebulaPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
