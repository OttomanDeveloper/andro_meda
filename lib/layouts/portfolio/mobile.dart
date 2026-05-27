import 'package:safeandromeda/core/hooks/hooks.dart';

class PortfolioMobileLayout extends StatelessWidget {
  const PortfolioMobileLayout({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppText.portfolioIntro,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioSubtext,
              fontSize: size.height * 0.018 * 0.65,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            AppText.portfolioName,
            textAlign: TextAlign.center,
            style: GoogleFonts.russoOne(
              color: AppColors.portfolioText,
              fontSize: size.height * 0.06 * 0.65,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: AppColors.portfolioAccent.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            AppText.portfolioRole,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioAccent,
              fontSize: size.height * 0.02 * 0.65,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Container(
            width: size.width * 0.15,
            height: size.height * 0.002,
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
          SizedBox(height: size.height * 0.015),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Text(
              AppText.portfolioTagline,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColors.portfolioSubtext,
                fontSize: size.height * 0.016 * 0.65,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.025),
          Column(
            children: [
              _PortfolioLink(
                text: AppText.portfolioGithub,
                size: size,
              ),
              SizedBox(height: size.height * 0.01),
              _PortfolioLink(
                text: AppText.portfolioEmail,
                size: size,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PortfolioLink extends StatelessWidget {
  const _PortfolioLink({
    required this.text,
    required this.size,
  });

  final String text;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        color: AppColors.portfolioAccent.withValues(alpha: 0.7),
        fontSize: size.height * 0.014 * 0.65,
        letterSpacing: 1,
      ),
    );
  }
}
