import 'package:safeandromeda/core/hooks/hooks.dart';

/// Final "crafted by" screen. Picks a breakpoint layout; all three render the
/// same [PortfolioContent] at different scale factors.
class PortfolioReveal extends StatelessWidget {
  const PortfolioReveal({super.key});

  /// Routes to the mobile/tablet/desktop layout for the current width.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Responsive(
      mobile: PortfolioMobileLayout(size: size),
      tablet: PortfolioTabletLayout(size: size),
      desktop: PortfolioDesktopLayout(size: size),
    );
  }
}

/// The shared "developer reveal" card used by every breakpoint. Everything is
/// driven off [scaleFactor] so the three layouts stay in sync.
class PortfolioContent extends StatelessWidget {
  const PortfolioContent({
    super.key,
    required this.size,
    this.scaleFactor = 1.0,
  });

  final Size size; // available screen size; every dimension scales off this
  final double
  scaleFactor; // breakpoint multiplier: desktop 1.0, tablet 0.8, mobile 0.65

  /// Builds the centered scrollable card: intro, name, role, stats, tech, links.
  @override
  Widget build(BuildContext context) {
    final double h = size.height; // base unit for vertical/text sizing
    final double s = scaleFactor; // local alias for the scale multiplier

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            AppColors.portfolioBg,
            AppColors.portfolioBg.withValues(alpha: 0.95),
            const Color(0xffe0e0e8),
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: h * 0.05,
            horizontal: size.width * 0.06,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppText.portfolioIntro,
                style: GoogleFonts.roboto(
                  color: AppColors.portfolioSubtext,
                  fontSize: h * 0.018 * s,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: h * 0.02),
              Text(
                AppText.portfolioName,
                textAlign: TextAlign.center,
                style: GoogleFonts.russoOne(
                  color: AppColors.portfolioText,
                  fontSize: h * 0.06 * s,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: AppColors.portfolioAccent.withValues(alpha: 0.3),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.012),
              Text(
                AppText.portfolioRole,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.portfolioAccent,
                  fontSize: h * 0.02 * s,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: h * 0.004),
              Text(
                AppText.portfolioSubrole,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.portfolioSubtext,
                  fontSize: h * 0.013 * s,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: h * 0.018),
              // Thin glowing divider that fades out at both ends.
              Container(
                width: size.width * 0.1,
                height: h * 0.002,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.portfolioAccent.withValues(alpha: 0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      AppColors.portfolioAccent.withValues(alpha: 0.0),
                      AppColors.portfolioAccent.withValues(alpha: 0.6),
                      AppColors.portfolioAccent.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 0.018),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Text(
                  AppText.portfolioTagline,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: AppColors.portfolioSubtext,
                    fontSize: h * 0.016 * s,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: h * 0.03),
              // Stat chips: each entry is [value, label].
              Wrap(
                alignment: WrapAlignment.center,
                spacing: size.width * 0.018,
                runSpacing: h * 0.018,
                children: [
                  for (final List<String> stat in AppText.portfolioStats)
                    _StatChip(value: stat[0], label: stat[1], h: h, s: s),
                ],
              ),
              SizedBox(height: h * 0.03),
              // Tech-stack pills.
              Wrap(
                alignment: WrapAlignment.center,
                spacing: size.width * 0.008,
                runSpacing: h * 0.01,
                children: [
                  for (final String tech in AppText.portfolioTech)
                    _TechPill(label: tech, h: h, s: s),
                ],
              ),
              SizedBox(height: h * 0.03),
              // Contact / social links.
              Wrap(
                alignment: WrapAlignment.center,
                spacing: size.width * 0.025,
                runSpacing: h * 0.012,
                children: [
                  _PortfolioLink(text: AppText.portfolioGithub, h: h, s: s),
                  _PortfolioLink(text: AppText.portfolioLinkedIn, h: h, s: s),
                  _PortfolioLink(text: AppText.portfolioYouTube, h: h, s: s),
                  _PortfolioLink(text: AppText.portfolioEmail, h: h, s: s),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A headline metric: a bold value over a small caption, in a soft card.
class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.value,
    required this.label,
    required this.h,
    required this.s,
  });

  final String value; // bold metric, e.g. "5+"
  final String label; // caption under the value
  final double h; // screen height base unit
  final double s; // scale factor

  /// Builds the value-over-label card.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: h * 0.022 * s,
        vertical: h * 0.014 * s,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(h * 0.012),
        border: Border.all(
          color: AppColors.portfolioAccent.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.russoOne(
              color: AppColors.portfolioText,
              fontSize: h * 0.026 * s,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: h * 0.004),
          Text(
            label,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioSubtext,
              fontSize: h * 0.012 * s,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// A stack-tech pill.
class _TechPill extends StatelessWidget {
  const _TechPill({required this.label, required this.h, required this.s});

  final String label; // tech name shown in the pill
  final double h; // screen height base unit
  final double s; // scale factor

  /// Builds the outlined accent pill.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: h * 0.016 * s,
        vertical: h * 0.006 * s,
      ),
      decoration: BoxDecoration(
        color: AppColors.portfolioAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(h * 0.02),
        border: Border.all(
          color: AppColors.portfolioAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          color: AppColors.portfolioAccent,
          fontSize: h * 0.013 * s,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// A single contact/social link rendered as accent-colored text.
class _PortfolioLink extends StatelessWidget {
  const _PortfolioLink({required this.text, required this.h, required this.s});

  final String text; // link label/handle
  final double h; // screen height base unit
  final double s; // scale factor

  /// Builds the link text (display only; no tap handler).
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        color: AppColors.portfolioAccent.withValues(alpha: 0.75),
        fontSize: h * 0.014 * s,
        letterSpacing: 1,
      ),
    );
  }
}
