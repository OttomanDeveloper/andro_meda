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
                  backgroundColor: AppColors.darkAgesBg,
                  nextBackgroundColor: AppColors.firstStarsBg,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: NebulaPainter(
                            progress: progress,
                            clouds: _wisps,
                            time: anim.time,
                            cursorX: cursor.normalizedX,
                            cursorY: cursor.normalizedY,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.sizeOf(context).height * 0.12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _TypewriterText(
                            text: '200 million years of silence...',
                            progress: progress,
                            startAt: 0.15,
                            style: GoogleFonts.roboto(
                              color:
                                  AppColors.white.withValues(alpha: 0.15),
                              fontSize:
                                  MediaQuery.sizeOf(context).height * 0.016,
                              letterSpacing: 3,
                              shadows: [
                                Shadow(
                                  color: AppColors.darkAgesWisp
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ForegroundPainter(
                            time: anim.time,
                            color: AppColors.darkAgesHydrogen,
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

class _TypewriterText extends StatelessWidget {
  const _TypewriterText({
    required this.text,
    required this.progress,
    required this.startAt,
    required this.style,
  });

  final String text;
  final double progress;
  final double startAt;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final double typeProgress = ((progress - startAt) / 0.3).clamp(0.0, 1.0);
    final int charCount = (typeProgress * text.length).floor();
    if (charCount <= 0) return const SizedBox();

    return Text(
      text.substring(0, charCount),
      style: style,
    );
  }
}
