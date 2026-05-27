import 'package:safeandromeda/core/hooks/hooks.dart';

class EraWrapper extends StatelessWidget {
  const EraWrapper({
    super.key,
    required this.eraIndex,
    required this.child,
    this.backgroundColor = AppColors.black,
    this.nextBackgroundColor = AppColors.black,
    this.useDarkText = false,
    this.interactionHint,
  });

  final int eraIndex;
  final Widget child;
  final Color backgroundColor;
  final Color nextBackgroundColor;
  final bool useDarkText;
  final String? interactionHint;

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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backgroundColor,
                Color.lerp(backgroundColor, nextBackgroundColor, progress) ??
                    backgroundColor,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: child),
              Positioned(
                left: 0,
                right: 0,
                top: (size.height * 0.3) + parallaxOffset,
                child: Transform.translate(
                  offset: Offset(0, _entranceOffset(progress, size.height)),
                  child: Transform.scale(
                    scale: _entranceScale(progress),
                    child: Opacity(
                      opacity: textOpacity,
                      child: _EraTextContent(
                        eraIndex: eraIndex,
                        useDarkText: useDarkText,
                        interactionHint: interactionHint,
                        progress: progress,
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

  double _entranceOffset(double progress, double viewportHeight) {
    if (progress < 0.15) {
      final double t = progress / 0.15;
      return viewportHeight * 0.05 * (1.0 - Curves.easeOutCubic.transform(t));
    }
    if (progress > 0.75) {
      final double t = (progress - 0.75) / 0.25;
      return viewportHeight * -0.03 * Curves.easeInCubic.transform(t);
    }
    return 0;
  }

  double _entranceScale(double progress) {
    if (progress < 0.15) {
      final double t = progress / 0.15;
      return 0.92 + 0.08 * Curves.easeOutCubic.transform(t);
    }
    return 1.0;
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
  const _EraTextContent({
    required this.eraIndex,
    required this.useDarkText,
    required this.progress,
    this.interactionHint,
  });

  final int eraIndex;
  final bool useDarkText;
  final double progress;
  final String? interactionHint;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool isMobile = Responsive.isMobile(context);
    final bool isTablet = Responsive.isTablet(context);
    final double scaleFactor = isMobile ? 0.65 : isTablet ? 0.8 : 1.0;
    final double horizontalPadding = isMobile ? 0.06 : 0.1;
    final double descriptionWidth = isMobile ? 0.85 : isTablet ? 0.65 : 0.5;

    final Color timestampColor = useDarkText
        ? AppColors.portfolioText.withValues(alpha: 0.4)
        : AppColors.white.withValues(alpha: 0.4);
    final Color headlineColor =
        useDarkText ? AppColors.portfolioText : AppColors.white;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppText.eraTimestamps[eraIndex],
            style: GoogleFonts.roboto(
              color: timestampColor,
              fontSize: size.height * 0.014 * scaleFactor,
              letterSpacing: 6,
              shadows: [
                Shadow(
                  color: timestampColor.withValues(alpha: 0.7),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          _AnimatedHeadline(
            text: AppText.eraHeadlines[eraIndex],
            style: GoogleFonts.russoOne(
              color: headlineColor,
              fontSize: size.height * 0.055 * scaleFactor,
              letterSpacing: 3,
              shadows: [
                Shadow(
                  color: headlineColor.withValues(alpha: 0.8),
                  blurRadius: 30,
                ),
                Shadow(
                  color: headlineColor.withValues(alpha: 0.5),
                  blurRadius: 60,
                ),
              ],
            ),
            progress: progress,
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            width: size.width * 0.08,
            height: size.height * 0.001,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.parent,
                  headlineColor.withValues(alpha: 0.6),
                  AppColors.parent,
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          SizedBox(
            width: size.width * descriptionWidth,
            child: Text(
              AppText.eraDescriptions[eraIndex],
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: useDarkText
                    ? AppColors.portfolioText.withValues(alpha: 0.7)
                    : AppColors.white.withValues(alpha: 0.7),
                fontSize: size.height * 0.018 * scaleFactor,
                height: 1.7,
                shadows: [
                  Shadow(
                    color: AppColors.white.withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          if (interactionHint != null) ...[
            SizedBox(height: size.height * 0.025),
            Text(
              interactionHint!,
              style: GoogleFonts.roboto(
                color: AppColors.white.withValues(alpha: 0.3),
                fontSize: size.height * 0.012 * scaleFactor,
                letterSpacing: 3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnimatedHeadline extends StatelessWidget {
  const _AnimatedHeadline({
    required this.text,
    required this.style,
    required this.progress,
  });

  final String text;
  final TextStyle style;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final double charProgress = ((progress - 0.05) / 0.15).clamp(0.0, 1.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(text.length, (int i) {
        final double delay = i / text.length;
        final double charOpacity =
            ((charProgress - delay * 0.5) / 0.5).clamp(0.0, 1.0);
        final double charOffset = (1.0 - charOpacity) * 8;

        return Transform.translate(
          offset: Offset(0, charOffset),
          child: Opacity(
            opacity: charOpacity,
            child: Text(text[i], style: style),
          ),
        );
      }),
    );
  }
}
