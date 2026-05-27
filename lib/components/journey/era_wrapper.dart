import 'package:safeandromeda/core/hooks/hooks.dart';

class EraWrapper extends StatelessWidget {
  const EraWrapper({
    super.key,
    required this.eraIndex,
    required this.child,
    this.backgroundColor = AppColors.black,
  });

  final int eraIndex;
  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Consumer<ScrollProvider>(
      builder: (_, ScrollProvider pro, _) {
        final double progress = pro.eraProgressFor(eraIndex);

        final double textOpacity = _textOpacity(progress);
        final double parallaxOffset = _parallaxOffset(progress, size.height);

        return Container(
          width: size.width,
          height: size.height * AppSettings.eraHeightFactor,
          color: backgroundColor,
          child: Stack(
            children: [
              Positioned.fill(child: child),
              Positioned(
                left: 0,
                right: 0,
                top: (size.height * 0.3) + parallaxOffset,
                child: Opacity(
                  opacity: textOpacity,
                  child: _EraTextContent(
                    eraIndex: eraIndex,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _textOpacity(double progress) {
    if (progress < 0.15) return (progress / 0.15).clamp(0.0, 1.0);
    if (progress > 0.75) return ((1.0 - progress) / 0.25).clamp(0.0, 1.0);
    return 1.0;
  }

  double _parallaxOffset(double progress, double viewportHeight) {
    return (progress - 0.5) * viewportHeight * -0.15;
  }
}

class _EraTextContent extends StatelessWidget {
  const _EraTextContent({required this.eraIndex});

  final int eraIndex;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppText.eraTimestamps[eraIndex],
            style: GoogleFonts.roboto(
              color: AppColors.white.withValues(alpha: 0.4),
              fontSize: size.height * 0.014,
              letterSpacing: 6,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            AppText.eraHeadlines[eraIndex],
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.white,
              fontSize: size.height * 0.05,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          SizedBox(
            width: size.width * 0.5,
            child: Text(
              AppText.eraDescriptions[eraIndex],
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.white.withValues(alpha: 0.6),
                fontSize: size.height * 0.018,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
