import 'package:safeandromeda/core/hooks/hooks.dart';

class AnimationProvider extends ChangeNotifier {
  double _time = 0.0;
  double get time => _time;

  Timer? _timer;
  bool _disposed = false;

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (_disposed) {
        _timer?.cancel();
        return;
      }
      _time += 0.016;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
