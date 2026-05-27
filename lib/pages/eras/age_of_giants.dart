import 'package:safeandromeda/core/hooks/hooks.dart';

class AgeOfGiantsEra extends StatelessWidget {
  const AgeOfGiantsEra({super.key});

  static const int eraIndex = 6;

  static const List<NebulaCloud> _mist = [
    NebulaCloud(
        x: 0.2,
        y: 0.7,
        radius: 0.3,
        color: AppColors.giantsForest,
        opacity: 0.2,
        driftSpeed: 0.01),
    NebulaCloud(
        x: 0.7,
        y: 0.6,
        radius: 0.25,
        color: AppColors.giantsLeaf,
        opacity: 0.1,
        driftSpeed: -0.008),
    NebulaCloud(
        x: 0.5,
        y: 0.8,
        radius: 0.35,
        color: AppColors.giantsBg,
        opacity: 0.15,
        driftSpeed: 0.005),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Selector<ScrollProvider, double>(
      selector: (_, ScrollProvider pro) =>
          (pro.eraProgressFor(eraIndex) * 100).roundToDouble() / 100,
      builder: (_, double progress, _) {

        return EraWrapper(
          eraIndex: eraIndex,
          backgroundColor: AppColors.giantsBg,
          nextBackgroundColor: AppColors.humanityBg,
          interactionHint: isMobile ? 'TAP TO REVEAL' : 'HOVER TO REVEAL',
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.giantsBg, AppColors.giantsForest],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: NebulaPainter(progress: progress, clouds: _mist),
                ),
              ),
              Positioned.fill(
                child: CreatureRevealer(eraProgress: progress),
              ),
            ],
          ),
        );
      },
    );
  }
}
