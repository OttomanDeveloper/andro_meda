import 'package:safeandromeda/core/hooks/hooks.dart';

/// Accumulates the stars the user has ignited by tapping empty space.
class _StarIgniterProvider extends ChangeNotifier {
  final List<Offset> _ignitedStars = <Offset>[]; // local tap positions
  List<Offset> get ignitedStars => _ignitedStars;

  final List<double> _ignitedSizes = <double>[]; // core radius per star, px
  List<double> get ignitedSizes => _ignitedSizes;

  /// Records a new star at the tap point with the given core radius.
  void ignite(Offset position, double size) {
    _ignitedStars.add(position);
    _ignitedSizes.add(size);
    notifyListeners();
  }
}

/// First-Stars widget: tap empty space to ignite a new star.
class StarIgniter extends StatelessWidget {
  const StarIgniter({super.key, required this.eraProgress});

  final double eraProgress; // era scroll progress, 0..1

  /// Scopes the ignited-stars provider to this widget's subtree.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_StarIgniterProvider>(
      create: (_) => _StarIgniterProvider(),
      child: _StarIgniterBody(eraProgress: eraProgress),
    );
  }
}

/// Catches taps and repaints the growing set of ignited stars.
class _StarIgniterBody extends StatelessWidget {
  const _StarIgniterBody({required this.eraProgress});

  final double eraProgress; // era scroll progress, 0..1

  /// Rebuilds whenever a star is added.
  @override
  Widget build(BuildContext context) {
    return Consumer<_StarIgniterProvider>(
      builder: (_, _StarIgniterProvider pro, _) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            final Random r = Random();
            // Core radius 3..8 px, randomized so stars vary in size.
            pro.ignite(details.localPosition, 3.0 + r.nextDouble() * 5.0);
          },
          behavior: HitTestBehavior.translucent,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: IgnitedStarsPainter(
                stars: pro.ignitedStars,
                sizes: pro.ignitedSizes,
                progress: eraProgress,
              ),
            ),
          ),
        );
      },
    );
  }
}
