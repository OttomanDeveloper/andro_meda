import 'package:safeandromeda/core/hooks/hooks.dart';

class PortfolioMobileLayout extends StatelessWidget {
  const PortfolioMobileLayout({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.portfolioBg,
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
            width: size.width * 0.12,
            height: size.height * 0.002,
            color: AppColors.portfolioAccent.withValues(alpha: 0.4),
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
        ],
      ),
    );
  }
}
