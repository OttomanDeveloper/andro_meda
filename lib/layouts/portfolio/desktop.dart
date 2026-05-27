import 'package:safeandromeda/core/hooks/hooks.dart';

class PortfolioDesktopLayout extends StatelessWidget {
  const PortfolioDesktopLayout({super.key, required this.size});

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
              fontSize: size.height * 0.018,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            AppText.portfolioName,
            style: GoogleFonts.russoOne(
              color: AppColors.portfolioText,
              fontSize: size.height * 0.06,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            AppText.portfolioRole,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioAccent,
              fontSize: size.height * 0.02,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Container(
            width: size.width * 0.06,
            height: size.height * 0.002,
            color: AppColors.portfolioAccent.withValues(alpha: 0.4),
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            AppText.portfolioTagline,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioSubtext,
              fontSize: size.height * 0.016,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
