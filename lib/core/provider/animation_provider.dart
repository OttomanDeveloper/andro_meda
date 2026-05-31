import 'package:safeandromeda/core/hooks/hooks.dart';

/// Holds the global animation clock fed by the single app Ticker. Painters read
/// `time` to drive every scene's motion off one shared timeline.
class AnimationProvider extends ChangeNotifier {
  double _time = 0.0; // elapsed seconds since the Ticker started
  double get time => _time; // global animation clock, in seconds

  /// Advances the clock to [seconds] and rebuilds listeners. Called once per frame.
  void updateTime(double seconds) {
    _time = seconds;
    notifyListeners();
  }
}
