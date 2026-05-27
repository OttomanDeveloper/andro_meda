import 'package:safeandromeda/core/hooks/hooks.dart';

class CursorProvider extends ChangeNotifier {
  Offset _position = Offset.zero;
  Offset get position => _position;

  double _normalizedX = 0.0;
  double get normalizedX => _normalizedX;

  double _normalizedY = 0.0;
  double get normalizedY => _normalizedY;

  void updatePosition(Offset position, Size viewportSize) {
    _position = position;
    _normalizedX = (position.dx / viewportSize.width - 0.5) * 2;
    _normalizedY = (position.dy / viewportSize.height - 0.5) * 2;
    notifyListeners();
  }
}
