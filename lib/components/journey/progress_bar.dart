import 'package:safeandromeda/core/hooks/hooks.dart';

/// Top scrubber: app name, current era label, and a tap-to-jump progress bar.
class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  /// Builds the fixed header bar; rebuilds on every [ScrollProvider] change.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool isMobile = Responsive.isMobile(context);

    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, _) {
        return Container(
          width: size.width,
          padding: EdgeInsets.symmetric(
            horizontal: size.width * (isMobile ? 0.03 : 0.04),
            vertical: size.height * 0.015,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isMobile)
                    Text(
                      AppSettings.appName.toUpperCase(),
                      style: GoogleFonts.russoOne(
                        color: AppColors.white.withValues(alpha: 0.6),
                        fontSize: size.height * 0.014,
                        letterSpacing: 4,
                      ),
                    ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      pro.eraLabel,
                      key: ValueKey<int>(pro.currentEra),
                      style: GoogleFonts.roboto(
                        color: AppColors.eraLabelText,
                        fontSize: size.height * 0.014,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.008),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  // Map horizontal tap position to an era index and scroll there.
                  final double tapFraction =
                      details.localPosition.dx / size.width;
                  final int targetEra = (tapFraction * AppSettings.eraCount)
                      .floor()
                      .clamp(0, AppSettings.eraCount - 1);
                  pro.jumpToEra(targetEra);
                },
                child: Container(
                  width: size.width,
                  height: size.height * (isMobile ? 0.004 : 0.005),
                  decoration: BoxDecoration(
                    color: AppColors.progressBg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    // Fill width tracks total journey progress across all eras.
                    widthFactor: pro.overallProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.progressFill,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.progressFill.withValues(
                              alpha: 0.7,
                            ),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
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
