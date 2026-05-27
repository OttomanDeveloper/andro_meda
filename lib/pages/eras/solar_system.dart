import 'package:safeandromeda/core/hooks/hooks.dart';

class SolarSystemEra extends StatelessWidget {
  const SolarSystemEra({super.key});

  static const int eraIndex = 4;

  static const List<OrbitRing> _orbits = [
    OrbitRing(
        radiusX: 0.06,
        radiusY: 0.04,
        planetColor: Color(0xffaa8866),
        planetSize: 3,
        speed: 4.0),
    OrbitRing(
        radiusX: 0.1,
        radiusY: 0.065,
        planetColor: Color(0xffeebb66),
        planetSize: 4,
        speed: 2.5),
    OrbitRing(
        radiusX: 0.15,
        radiusY: 0.1,
        planetColor: Color(0xff4488cc),
        planetSize: 5,
        speed: 1.8),
    OrbitRing(
        radiusX: 0.19,
        radiusY: 0.13,
        planetColor: Color(0xffcc4422),
        planetSize: 4,
        speed: 1.2),
    OrbitRing(
        radiusX: 0.27,
        radiusY: 0.18,
        planetColor: Color(0xffddaa66),
        planetSize: 8,
        speed: 0.6),
    OrbitRing(
        radiusX: 0.34,
        radiusY: 0.22,
        planetColor: Color(0xffccbb88),
        planetSize: 7,
        speed: 0.4),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, _) {
        final double progress = pro.eraProgressFor(eraIndex);

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
                    starCount: 80,
                    baseColor: AppColors.white,
                    maxOpacity: 0.3,
                    seed: 456,
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: OrbitPainter(
                    progress: progress,
                    orbits: _orbits,
                    centerColor: AppColors.solarSun,
                    centerRadius: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
