import 'package:safeandromeda/core/hooks/hooks.dart';

class StarFieldPainter extends CustomPainter {
  const StarFieldPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
