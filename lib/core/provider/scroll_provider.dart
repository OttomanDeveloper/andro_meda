import 'package:safeandromeda/core/hooks/hooks.dart';

class ScrollProvider extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  int _currentEra = 0;
  int get currentEra => _currentEra;

  double _overallProgress = 0.0;
  double get overallProgress => _overallProgress;

  double _eraProgress = 0.0;
  double get eraProgress => _eraProgress;

  double _scrollVelocity = 0.0;
  double get scrollVelocity => _scrollVelocity;

  double _lastOffset = 0.0;

  String get eraLabel => AppText.eraNames[_currentEra];

  double _viewportHeight = 0.0;
  bool _initialized = false;

  void initScroll(double viewportHeight) {
    _viewportHeight = viewportHeight;
    if (!_initialized) {
      _scrollController.addListener(_onScroll);
      _initialized = true;
    }
  }

  void _onScroll() {
    final double newOffset = _scrollController.offset;
    _scrollVelocity = (newOffset - _lastOffset).abs().clamp(0.0, 50.0) / 50.0;
    _lastOffset = newOffset;

    final double eraHeight = _viewportHeight * AppSettings.eraHeightFactor;
    final double totalHeight = eraHeight * AppSettings.eraCount;

    _overallProgress = (newOffset / totalHeight).clamp(0.0, 1.0);

    final int newEra = (newOffset / eraHeight).floor().clamp(0, AppSettings.eraCount - 1);
    _eraProgress = ((newOffset - (newEra * eraHeight)) / eraHeight).clamp(0.0, 1.0);

    if (newEra != _currentEra) {
      _currentEra = newEra;
    }

    notifyListeners();
  }

  double eraProgressFor(int eraIndex) {
    final double eraHeight = _viewportHeight * AppSettings.eraHeightFactor;
    final double eraStart = eraIndex * eraHeight;
    final double offset = _scrollController.offset;
    return ((offset - eraStart) / eraHeight).clamp(0.0, 1.0);
  }

  void jumpToEra(int eraIndex) {
    final double eraHeight = _viewportHeight * AppSettings.eraHeightFactor;
    _scrollController.animateTo(
      eraIndex * eraHeight,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
