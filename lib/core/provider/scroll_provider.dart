import 'package:safeandromeda/core/hooks/hooks.dart';

/// Owns the page ScrollController and derives scroll-driven state: which era is
/// active, per-era progress, overall progress, and scroll velocity.
class ScrollProvider extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  int _currentEra = 0; // index of the era currently in view, 0..eraCount-1
  int get currentEra => _currentEra;

  double _overallProgress = 0.0; // progress through the whole timeline, 0..1
  double get overallProgress => _overallProgress;

  double _eraProgress =
      0.0; // progress within the current era, 0 at entry .. 1 at exit
  double get eraProgress => _eraProgress;

  double _scrollVelocity = 0.0; // recent scroll speed normalized to 0..1
  double get scrollVelocity => _scrollVelocity;

  double _lastOffset =
      0.0; // scroll offset from the previous frame, for velocity

  String get eraLabel =>
      AppText.eraNames[_currentEra]; // display name of the active era

  double _viewportHeight =
      0.0; // current viewport height in pixels; sets era length
  bool _initialized = false; // guards against attaching the listener twice

  /// Records the [viewportHeight] and attaches the scroll listener once.
  void initScroll(double viewportHeight) {
    _viewportHeight = viewportHeight;
    if (!_initialized) {
      _scrollController.addListener(_onScroll);
      _initialized = true;
    }
  }

  /// Recomputes velocity, active era, and progress values on each scroll tick.
  void _onScroll() {
    final double newOffset = _scrollController.offset;
    // Per-frame delta capped at 50px then scaled to 0..1.
    _scrollVelocity = (newOffset - _lastOffset).abs().clamp(0.0, 50.0) / 50.0;
    _lastOffset = newOffset;

    final double eraHeight =
        _viewportHeight * AppSettings.eraHeightFactor; // pixels per era
    final double totalHeight =
        eraHeight * AppSettings.eraCount; // full scrollable height

    _overallProgress = (newOffset / totalHeight).clamp(0.0, 1.0);

    // Active era is the offset divided into era-height bands.
    final int newEra = (newOffset / eraHeight).floor().clamp(
      0,
      AppSettings.eraCount - 1,
    );
    // Fraction scrolled within that band.
    _eraProgress = ((newOffset - (newEra * eraHeight)) / eraHeight).clamp(
      0.0,
      1.0,
    );

    if (newEra != _currentEra) {
      _currentEra = newEra;
    }

    notifyListeners();
  }

  /// Progress (0..1) through the era at [eraIndex], regardless of which era is active.
  double eraProgressFor(int eraIndex) {
    final double eraHeight = _viewportHeight * AppSettings.eraHeightFactor;
    final double eraStart =
        eraIndex * eraHeight; // scroll offset where this era begins
    final double offset = _scrollController.offset;
    return ((offset - eraStart) / eraHeight).clamp(0.0, 1.0);
  }

  /// Animates the scroll position to the top of the era at [eraIndex] over 800ms.
  void jumpToEra(int eraIndex) {
    final double eraHeight = _viewportHeight * AppSettings.eraHeightFactor;
    _scrollController.animateTo(
      eraIndex * eraHeight,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Detaches the listener and disposes the controller.
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
