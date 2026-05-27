import 'package:safeandromeda/core/hooks/hooks.dart';

class AnimationProvider extends ChangeNotifier {
  double _time = 0.0;
  double get time => _time;

  void updateTime(double seconds) {
    _time = seconds;
    notifyListeners();
  }
}
