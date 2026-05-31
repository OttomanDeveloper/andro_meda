import 'package:safeandromeda/core/hooks/hooks.dart';

/// Signature for an era's scene, parameterised by the values that drive it.
///
/// [time] is the global animation clock in seconds (frozen at 0 while the era
/// is off-screen), [progress] is this era's scroll progress in [0, 1], and
/// [cursorX]/[cursorY] are the normalised cursor offsets in [-1, 1] used for
/// parallax (0 while off-screen).
typedef EraSceneBuilder =
    Widget Function(
      BuildContext context,
      double time,
      double progress,
      double cursorX,
      double cursorY,
    );

/// Drives an era's per-frame animation only while it is near the viewport.
///
/// Every era subscribes to [AnimationProvider] (which notifies once per Ticker
/// frame) and [CursorProvider] (which notifies on every pointer move). Because
/// the journey builds all eras eagerly inside a single scroll view, without
/// gating every off-screen era would rebuild and repaint every frame.
///
/// [EraScope] subscribes to those providers only for the active era, the one
/// containing the viewport, plus one neighbour on each side to cover the
/// transition overlap (eras are [AppSettings.eraHeightFactor]x the viewport
/// tall, so two can be on screen at once). Inactive eras render a single frozen
/// frame and stay cached behind their `RepaintBoundary`.
class EraScope extends StatelessWidget {
  const EraScope({super.key, required this.eraIndex, required this.builder});

  final int eraIndex;
  final EraSceneBuilder builder;

  /// How many eras on either side of the current one stay animated.
  static const int _neighbourRange = 1;

  @override
  Widget build(BuildContext context) {
    return Selector<ScrollProvider, ({bool active, double progress})>(
      selector: (_, ScrollProvider pro) => (
        active: (pro.currentEra - eraIndex).abs() <= _neighbourRange,
        // Quantised to 1% steps so scrolling rebuilds ~100x, not every pixel.
        progress: (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
      ),
      builder: (BuildContext context, ({bool active, double progress}) data, _) {
        if (!data.active) {
          // Off-screen: no AnimationProvider/CursorProvider subscription, so
          // this era stops rebuilding every frame and stays frozen.
          return builder(context, 0.0, data.progress, 0.0, 0.0);
        }
        return Consumer<CursorProvider>(
          builder: (BuildContext context, CursorProvider cursor, _) {
            return Consumer<AnimationProvider>(
              builder: (BuildContext context, AnimationProvider anim, _) {
                return builder(
                  context,
                  anim.time,
                  data.progress,
                  cursor.normalizedX,
                  cursor.normalizedY,
                );
              },
            );
          },
        );
      },
    );
  }
}
