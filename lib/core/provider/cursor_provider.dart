import 'package:safeandromeda/core/hooks/hooks.dart';

/// Tracks pointer position and exposes normalized coordinates that painters use
/// for parallax. Center of the viewport maps to (0, 0).
class CursorProvider extends ChangeNotifier {
  Offset _position = Offset.zero; // raw pointer position in viewport pixels
  Offset get position => _position;

  double _normalizedX = 0.0; // -1 at left edge, 0 at center, +1 at right edge
  double get normalizedX => _normalizedX;

  double _normalizedY = 0.0; // -1 at top edge, 0 at center, +1 at bottom edge
  double get normalizedY => _normalizedY;

  /// Stores [position] and recomputes the normalized -1..1 coordinates against
  /// [viewportSize]. Called on every pointer move.
  void updatePosition(Offset position, Size viewportSize) {
    _position = position;
    // Map 0..1 fraction of each axis to -1..1 centered on the viewport middle.
    _normalizedX = (position.dx / viewportSize.width - 0.5) * 2;
    _normalizedY = (position.dy / viewportSize.height - 0.5) * 2;
    notifyListeners();
  }
}
