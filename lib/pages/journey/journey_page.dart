import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:safeandromeda/core/hooks/hooks.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key});

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    context.read<AnimationProvider>().updateTime(
      elapsed.inMilliseconds / 1000.0,
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ScrollProvider scrollPro = context.read<ScrollProvider>();
    scrollPro.initScroll(size.height);

    return MaterialApp(
      title: AppSettings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: AppColors.parent),
      home: Scaffold(
        backgroundColor: AppColors.bigBangVoid,
        body: MouseRegion(
          onHover: (PointerHoverEvent event) {
            context
                .read<CursorProvider>()
                .updatePosition(event.position, size);
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollPro.scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Column(
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
                        height: size.height,
                        child: const PortfolioReveal(),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ProgressBar(),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Consumer<CursorProvider>(
                    builder: (_, CursorProvider cursor, _) {
                      return Consumer<AnimationProvider>(
                        builder: (_, AnimationProvider anim, _) {
                          return CustomPaint(
                            painter: _CursorTrailPainter(
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

class _CursorTrailPainter extends CustomPainter {
  _CursorTrailPainter({required this.position, required this.time});

  final Offset position;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (int i = 0; i < 6; i++) {
      final double offsetX = sin(time * 3 + i) * (3 + i * 2);
      final double offsetY = cos(time * 2.5 + i * 0.7) * (2 + i * 1.5);
      final double alpha = (0.4 - i * 0.06).clamp(0.0, 0.4);
      final double radius = 2.0 - i * 0.2;

      paint.color = const Color(0xffffffff).withValues(alpha: alpha);
      paint.maskFilter = null;
      canvas.drawCircle(
        Offset(position.dx + offsetX, position.dy + offsetY),
        radius,
        paint,
      );

      paint.color =
          const Color(0xffffffff).withValues(alpha: alpha * 0.3);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(
        Offset(position.dx + offsetX, position.dy + offsetY),
        radius * 3,
        paint,
      );
      paint.maskFilter = null;
    }
  }

  @override
  bool shouldRepaint(covariant _CursorTrailPainter old) => true;
}
