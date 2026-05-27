import 'package:safeandromeda/core/hooks/hooks.dart';

class AnimationProvider extends ChangeNotifier {
  double _time = 0.0;
  double get time => _time;

  Timer? _timer;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _time += 0.016;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
