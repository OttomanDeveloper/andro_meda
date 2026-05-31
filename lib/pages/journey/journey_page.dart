import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:safeandromeda/core/hooks/hooks.dart';

/// Root scaffold: one ticker, a scrolling column of the 9 eras, the progress
/// bar, and the cursor trail overlay.
class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key});

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker; // drives the global animation clock

  /// Starts the ticker that feeds AnimationProvider its time value.
  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  /// Pushes elapsed seconds (ms/1000) into the animation clock every frame.
  void _onTick(Duration elapsed) {
    context.read<AnimationProvider>().updateTime(
      elapsed.inMilliseconds / 1000.0,
    );
  }

  /// Stops the ticker to release the frame callback.
  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  /// Builds the scroll view of eras plus the fixed progress bar and trail.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ScrollProvider scrollPro = context.read<ScrollProvider>();
    scrollPro.initScroll(
      size.height,
    ); // hand viewport height so it can map scroll → per-era progress

    return MaterialApp(
      title: AppSettings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: AppColors.parent),
      home: Scaffold(
        backgroundColor: AppColors.bigBangVoid,
        body: MouseRegion(
          // Feed hover position to the cursor trail painter.
          onHover: (PointerHoverEvent event) {
            context.read<CursorProvider>().updatePosition(event.position, size);
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                controller:
                    scrollPro.scrollController, // shared with ScrollProvider
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Column(
                  // 9 eras in chronological order, then the portfolio reveal.
                  // Each era is one scroll-page tall and isolated in a
                  // RepaintBoundary so its painter doesn't repaint neighbours.
                  children: [
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const BigBangEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const DarkAgesEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const FirstStarsEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const GalaxiesEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const SolarSystemEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const LifeBeginsEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const AgeOfGiantsEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const HumanityEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size.height * AppSettings.eraHeightFactor,
                        child: const FutureEra(),
                      ),
                    ),
                    RepaintBoundary(
                      child: SizedBox(
                        height: size
                            .height, // final card is exactly one viewport, no era factor
                        child: const PortfolioReveal(),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(top: 0, left: 0, right: 0, child: ProgressBar()),
              // Cursor trail overlay: full-bleed, non-interactive, repaints with the clock.
              Positioned.fill(
                child: IgnorePointer(
                  child: Consumer<CursorProvider>(
                    builder: (_, CursorProvider cursor, _) {
                      return Consumer<AnimationProvider>(
                        builder: (_, AnimationProvider anim, _) {
                          return CustomPaint(
                            painter: CursorTrailPainter(
                              position: cursor.position,
                              time: anim.time,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
