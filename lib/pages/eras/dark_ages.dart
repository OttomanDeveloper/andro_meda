import 'package:safeandromeda/core/hooks/hooks.dart';

class DarkAgesEra extends StatelessWidget {
  const DarkAgesEra({super.key});

  static const int eraIndex = 1;

  static const List<NebulaCloud> _wisps = [
    NebulaCloud(
        x: 0.3,
        y: 0.4,
        radius: 0.15,
        color: AppColors.darkAgesHydrogen,
        opacity: 0.08,
        driftSpeed: 0.02),
    NebulaCloud(
        x: 0.6,
        y: 0.6,
        radius: 0.12,
        color: AppColors.darkAgesWisp,
        opacity: 0.05,
        driftSpeed: -0.015),
    NebulaCloud(
        x: 0.8,
        y: 0.3,
        radius: 0.1,
        color: AppColors.darkAgesHydrogen,
        opacity: 0.06,
        driftSpeed: 0.01),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationProvider>(
      builder: (_, AnimationProvider anim, _) {
        return Selector<ScrollProvider, double>(
          selector: (_, ScrollProvider pro) =>
              (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
          builder: (_, double progress, _) {
            return EraWrapper(
              eraIndex: eraIndex,
              backgroundColor: AppColors.darkAgesBg,
              nextBackgroundColor: AppColors.firstStarsBg,
              child: CustomPaint(
                painter: NebulaPainter(
                  progress: progress,
                  clouds: _wisps,
                  time: anim.time,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
