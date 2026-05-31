import 'package:safeandromeda/core/hooks/hooks.dart';

/// Holds the user-driven galaxy spin and the post-drag momentum spin-down.
class _GalaxyRotatorProvider extends ChangeNotifier {
  double _rotation = 0.0; // accumulated user rotation, radians
  double get rotation => _rotation;

  double _velocity = 0.0; // radians per momentum tick
  Timer? _momentumTimer;

  /// Applies a drag step and records it as the current velocity.
  void rotate(double delta) {
    _rotation += delta;
    _velocity = delta;
    notifyListeners();
  }

  /// Spins on after release, decaying velocity until it is negligible.
  void startMomentum() {
    _momentumTimer?.cancel();
    _momentumTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (_velocity.abs() < 0.0001) {
        // stop below ~0.006 deg/tick
        _momentumTimer?.cancel();
        return;
      }
      _velocity *= 0.95; // 5% friction per 16ms tick
      _rotation += _velocity;
      notifyListeners();
    });
  }

  /// Stops the momentum timer so it does not outlive the widget.
  @override
  void dispose() {
    _momentumTimer?.cancel();
    super.dispose();
  }
}

/// Galaxies-era widget: drag to spin a spiral, with momentum after release.
class GalaxyRotator extends StatelessWidget {
  const GalaxyRotator({super.key, required this.eraProgress});

  final double eraProgress; // era scroll progress, 0..1

  /// Scopes a rotation provider to this galaxy's subtree.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_GalaxyRotatorProvider>(
      create: (_) => _GalaxyRotatorProvider(),
      child: _GalaxyRotatorBody(eraProgress: eraProgress),
    );
  }
}

/// Wires drag gestures to the provider and feeds total rotation to the painter.
class _GalaxyRotatorBody extends StatelessWidget {
  const _GalaxyRotatorBody({required this.eraProgress});

  final double eraProgress; // era scroll progress, 0..1

  /// Repaints the spiral as the user spins, era scrolls, or clock advances.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<AnimationProvider>(
      builder: (_, AnimationProvider anim, _) {
        return Consumer<_GalaxyRotatorProvider>(
          builder: (_, _GalaxyRotatorProvider pro, _) {
            return GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                // Full viewport-width drag equals 2 radians of spin.
                pro.rotate(details.delta.dx / size.width * 2);
              },
              onPanEnd: (_) {
                pro.startMomentum();
              },
              behavior: HitTestBehavior.translucent,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: GalaxySpiralPainter(
                    // User spin + one full turn across the era + slow idle drift.
                    rotation:
                        pro.rotation + eraProgress * pi * 2 + anim.time * 0.3,
                    progress: eraProgress,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
