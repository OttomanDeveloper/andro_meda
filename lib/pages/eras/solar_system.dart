import 'package:safeandromeda/core/hooks/hooks.dart';

class SolarSystemEra extends StatelessWidget {
  const SolarSystemEra({super.key});

  static const int eraIndex = 4;

  static const List<OrbitRing> _orbits = [
    OrbitRing(
        radiusX: 0.078,
        radiusY: 0.052,
        planetColor: Color(0xffaa8866),
        planetSize: 4.5,
        speed: 4.0,
        name: 'Mercury'),
    OrbitRing(
        radiusX: 0.13,
        radiusY: 0.085,
        planetColor: Color(0xffeebb66),
        planetSize: 6,
        speed: 2.5,
        name: 'Venus'),
    OrbitRing(
        radiusX: 0.195,
        radiusY: 0.13,
        planetColor: Color(0xff4488cc),
        planetSize: 7.5,
        speed: 1.8,
        name: 'Earth'),
    OrbitRing(
        radiusX: 0.247,
        radiusY: 0.169,
        planetColor: Color(0xffcc4422),
        planetSize: 6,
        speed: 1.2,
        name: 'Mars'),
    OrbitRing(
        radiusX: 0.351,
        radiusY: 0.234,
        planetColor: Color(0xffddaa66),
        planetSize: 12,
        speed: 0.6,
        name: 'Jupiter'),
    OrbitRing(
        radiusX: 0.442,
        radiusY: 0.286,
        planetColor: Color(0xffccbb88),
        planetSize: 10.5,
        speed: 0.4,
        name: 'Saturn'),
  ];

  @override
  Widget build(BuildContext context) {
    final int starCount = AppSettings.particleCount(context, desktop: 80);

    return Consumer<CursorProvider>(
      builder: (_, CursorProvider cursor, _) {
        return Consumer<AnimationProvider>(
          builder: (_, AnimationProvider anim, _) {
            return Selector<ScrollProvider, double>(
              selector: (_, ScrollProvider pro) =>
                  (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
              builder: (_, double progress, _) {
                return EraWrapper(
                  eraIndex: eraIndex,
                  backgroundColor: AppColors.solarBg,
                  nextBackgroundColor: AppColors.lifeBg,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: StarFieldPainter(
                            progress: progress,
                            time: anim.time,
                            starCount: starCount,
                            baseColor: AppColors.white,
                            maxOpacity: 0.3,
                            seed: 456,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: OrbitPainter(
                            progress: progress,
                            orbits: _orbits,
                            centerColor: AppColors.solarSun,
                            centerRadius: 35,
                            time: anim.time,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.solarFlare,
                            seed: eraIndex * 100 + 99,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
