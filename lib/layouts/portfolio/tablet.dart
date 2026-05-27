import 'package:safeandromeda/core/hooks/hooks.dart';

class PortfolioTabletLayout extends StatelessWidget {
  const PortfolioTabletLayout({super.key, required this.size});

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
              fontSize: size.height * 0.018 * 0.8,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            AppText.portfolioName,
            style: GoogleFonts.russoOne(
              color: AppColors.portfolioText,
              fontSize: size.height * 0.06 * 0.8,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            AppText.portfolioRole,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioAccent,
              fontSize: size.height * 0.02 * 0.8,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Container(
            width: size.width * 0.08,
            height: size.height * 0.002,
            color: AppColors.portfolioAccent.withValues(alpha: 0.4),
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            AppText.portfolioTagline,
            style: GoogleFonts.roboto(
              color: AppColors.portfolioSubtext,
              fontSize: size.height * 0.016 * 0.8,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
